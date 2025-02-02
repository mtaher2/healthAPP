import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import '../Widget/buildTopButton.dart';
import 'home_screen.dart';
import 'modulesMenu.dart';

class QuizPage extends StatefulWidget {
  final String quizName;
  bool viewResult; // Optional
  bool retakeQuiz; // Optional

  QuizPage({
    required this.quizName,
    this.viewResult = false,
    this.retakeQuiz = false,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ConfettiController _confettiController;
  String resultText = "";
  int firstAttemptScore = 0;
  int secondAttemptScore = 0;
  int highestScore = 0;
  Map<String, dynamic> selectedAnswers = {};
  Map<String, dynamic> submittedAnswers = {};
  bool isSubmitting = false;
  bool hasSubmitted = false;
  bool test = false;
  int? totalScore;
  int currentQuestionIndex = 0;
  late List<Map<String, dynamic>> questions = [];

  // Data for first and second attempts
  Map<String, dynamic> firstAttemptData = {};
  Map<String, dynamic> secondAttemptData = {};

  Future<void> checkSubmissionStatus() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot<Map<String, dynamic>> quizDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('quizzes')
        .doc(widget.quizName)
        .get();

    if (quizDoc.exists) {
      Map<String, dynamic>? data = quizDoc.data();

      setState(() {
        hasSubmitted = true;

        // Fetch first and second attempts scores and answers
        firstAttemptData = data?['firstAttempt'] ?? {};
        secondAttemptData = data?['secondAttempt'] ?? {};

        submittedAnswers = data?['answers'] ?? {};
        totalScore = data?['score'];
        // Calculate highest score
        firstAttemptScore = firstAttemptData['score'] ?? 0;
        secondAttemptScore = secondAttemptData['score'] ?? 0;
        highestScore = firstAttemptScore > secondAttemptScore
            ? firstAttemptScore
            : secondAttemptScore;

        resultText =
            "First Attempt Score: $firstAttemptScore\nSecond Attempt Score: $secondAttemptScore\nHighest Score: $highestScore";

        totalScore = highestScore;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> quizDoc = await _firestore
          .collection('Modules')
          .doc('AINc83uOgA8i1W1quLgy') // Replace with your document ID
          .get();

      if (!quizDoc.exists) {
        throw Exception("Quiz document not found.");
      }

      Map<String, dynamic>? quizzesQuestion =
          quizDoc.data()?['quizzesQuestion'];
      Map<String, dynamic>? quiz = quizzesQuestion?[widget.quizName];

      if (quiz == null) {
        throw Exception("Quiz not found.");
      }

      return quiz.entries.map((entry) {
        final Map<String, dynamic> questionData =
            entry.value as Map<String, dynamic>;
        List<String> choices = List<String>.from(questionData['choices'] ?? []);
        return {
          "id": entry.key,
          "question": questionData["question"],
          "choices": choices,
          "correctAnswer": questionData["correctAnswer"],
          "scenario": questionData["scenario"],
          "rationale": questionData["rationale"],
          "points": questionData["points"],
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

Future<void> submitQuiz() async {
  if (isSubmitting) return;

  setState(() {
    isSubmitting = true;
  });

  try {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    // References for user and quiz
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
    DocumentReference quizDoc = userDoc.collection('quizzes').doc(widget.quizName);

    DocumentSnapshot quizSnapshot = await quizDoc.get();
    DocumentSnapshot userSnapshot = await userDoc.get();

    int allowAttempt = 2;
    int totalScore = userSnapshot.exists ? (userSnapshot.get('score') ?? 0) : 0;

    if (quizSnapshot.exists) {
      allowAttempt = quizSnapshot.get('allowAttempt') ?? 1;
    }

    if (allowAttempt == 0) {
      throw Exception("No attempts left for this quiz.");
    }

    // Decrease `allowAttempt` by 1 for the next attempt
    await quizDoc.set({"allowAttempt": allowAttempt - 1}, SetOptions(merge: true));

    // Calculate score and prepare answers
    int score = 0;
    Map<String, dynamic> answers = {};
    for (var question in questions) {
      String questionId = question["id"];
      String correctAnswer = question["correctAnswer"];
      String? userAnswer = selectedAnswers[questionId];

      if (userAnswer == correctAnswer) {
        score++;
      }

      answers[questionId] = {
        "answer": userAnswer,
        "correctAnswer": correctAnswer,
        "isCorrect": userAnswer == correctAnswer,
        "rationale": question["rationale"],
      };
    }

    int percentageScore = ((score / questions.length) * 100).round();

    if (allowAttempt == 2) {
      // First Attempt
      await quizDoc.set({
        "firstAttempt": {
          "answers": answers,
          "score": score,
        },
      }, SetOptions(merge: true));

      if (percentageScore >= 60) {
        _showCongratulationsDialog();
        await userDoc.update({"score": totalScore + 50}); // Add 50 points
      } else {
        _showSadMessage("You scored less than 60%. Try again for a better score!");
      }
    } else if (allowAttempt == 1) {
      // Second Attempt
      int firstAttemptScore = quizSnapshot.get('firstAttempt')['score'] ?? 0;
      int firstAttemptPercentage = ((firstAttemptScore / questions.length) * 100).round();

      await quizDoc.set({
        "secondAttempt": {
          "answers": answers,
          "score": score,
        },
      }, SetOptions(merge: true));

      if (firstAttemptPercentage >= 60) {
        // First attempt already passed; do nothing
      } else if (percentageScore >= 60) {
        _showCongratulationsDialog();
        await userDoc.update({"score": totalScore + 50}); // Add 50 points
      } else {
        _showSadMessage("You must study the module again. Keep trying!");
      }
    }

    setState(() {
      hasSubmitted = true;
      submittedAnswers = answers;
      totalScore = score;
    });
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error submitting quiz: $e")));
  } finally {
    setState(() {
      isSubmitting = false;
    });
  }
}

void _showCongratulationsDialog() {
  _confettiController.play();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.green, Colors.blue, Colors.orange],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎉 Congratulations!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You have completed this module and earned 50 points!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffA1D55D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showSadMessage(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("😔 Don't Give Up!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

@override
void initState() {
  super.initState();

  // Check quiz submission status and attempt limits
  checkSubmissionStatus();

  // Fetch quiz questions from Firestore
  fetchQuestions().then((fetchedQuestions) {
    setState(() {
      questions = fetchedQuestions;
    });
  }).catchError((error) {
    // Handle any errors during question fetching
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error loading questions: $error")),
    );
  });

  // Initialize confetti controller for celebration animation
  _confettiController = ConfettiController(duration: const Duration(seconds: 2));
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/galla_logo.jpeg',
                  height: screenHeight * 0.07,
                ),
                BuildTopButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulePage(),
                      ),
                    );
                  },
                  text: 'Back to Module',
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if ((hasSubmitted &&
        (widget.viewResult == true && widget.retakeQuiz == false))) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/galla_logo.jpeg',
                  height: screenHeight * 0.07,
                ),
                BuildTopButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulePage(),
                      ),
                    );
                  },
                  text: 'Back to Module',
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your Score: $totalScore/${questions.length}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // Display the result text based on the highest score
              Text(
                resultText, // Display the result text here
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final questionId = question["id"];

                    // Access the answers from both attempts
                    final firstAttemptAnswer =
                        firstAttemptData['answers']?[questionId];
                    final secondAttemptAnswer =
                        secondAttemptData['answers']?[questionId];

                    // Determine which attempt has the higher score (either first or second attempt)
                    final userAnswer = (firstAttemptScore >= secondAttemptScore)
                        ? firstAttemptAnswer
                        : secondAttemptAnswer;

                    // Extract user selected answer, correct answer, and check if it's correct
                    final userSelectedAnswer = userAnswer?['answer'];
                    final correctAnswer = question["correctAnswer"];
                    final isCorrect = userSelectedAnswer == correctAnswer;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question title
                            Container(
                              width: double.infinity,
                              color: Color(0xFFA1D55D),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Question ${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Scenario (if exists)
                            if (question["scenario"] != null)
                              Container(
                                color: Color(0xFFD9D9D9),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  question["scenario"],
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            // Question text
                            Text(
                              question["question"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            // Choices with background colors based on correctness
                            ...question["choices"].map<Widget>((choice) {
                              Color backgroundColor = Colors.white;

                              // If user selected this choice and it's correct
                              if (userSelectedAnswer == choice && isCorrect) {
                                backgroundColor =
                                    Colors.lightGreenAccent.withOpacity(0.5);
                              }
                              // If user selected this choice and it's incorrect
                              else if (userSelectedAnswer == choice &&
                                  !isCorrect) {
                                backgroundColor =
                                    Colors.redAccent.withOpacity(0.3);
                              }
                              // If this is the correct answer but user did not select it
                              else if (choice == correctAnswer) {
                                backgroundColor =
                                    Colors.lightGreenAccent.withOpacity(0.5);
                              }

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: choice,
                                      groupValue:
                                          userSelectedAnswer, // This ensures the selected answer is shown
                                      onChanged: null, // Disable interaction
                                    ),
                                    Expanded(
                                      child: Text(choice),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            // Rationale (if exists)
                            if (question["rationale"] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Rationale: ${question['rationale']}",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
            ],
          ),
        ),
      );
    } else if (hasSubmitted &&
        widget.retakeQuiz == false &&
        widget.viewResult == false) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/galla_logo.jpeg',
                  height: screenHeight * 0.07,
                ),
                BuildTopButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulePage(),
                      ),
                    );
                  },
                  text: 'Back to Module',
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your Score: $totalScore/${questions.length}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final questionId = question["id"];
                    final userAnswer = submittedAnswers[questionId]?["answer"];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question title
                            Container(
                              width: double.infinity,
                              color: Color(0xFFA1D55D),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Question ${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Scenario
                            if (question["scenario"] != null)
                              Container(
                                color: Color(0xFFD9D9D9),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  question["scenario"],
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            // Question text
                            Text(
                              question["question"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            // Choices with only user selection highlight
                            ...question["choices"].map<Widget>((choice) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: choice,
                                      groupValue: userAnswer,
                                      onChanged: null,
                                    ),
                                    Expanded(
                                      child: Text(choice),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logic to reset and retake the quiz
                  setState(() {
                    selectedAnswers.clear();
                    submittedAnswers.clear();
                    hasSubmitted = false;
                    currentQuestionIndex = 0;
                    totalScore = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA1D55D),
                ),
                child: Text(
                  "Retake Quiz",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Normal quiz page UI
    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];
    String questionId = currentQuestion["id"];
    List<String> choices = List<String>.from(currentQuestion["choices"]);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/galla_logo.jpeg',
                height: 50,
              ),
              if (hasSubmitted)
                BuildTopButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModulePage()),
                    );
                  },
                  text: 'Back to Module',
                  screenWidth: screenWidth,
                ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question title
            Container(
              color: Color(0xFFA1D55D),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                "Question ${currentQuestionIndex + 1}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Scenario
            if (currentQuestion["scenario"] != null)
              Container(
                color: Color(0xFFD9D9D9),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  currentQuestion["scenario"],
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            // Question text
            Text(
              currentQuestion["question"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            // Choices
            ...choices.map((choice) {
              return RadioListTile<String>(
                title: Text(choice),
                value: choice,
                groupValue: selectedAnswers[questionId],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[questionId] = value;
                  });
                },
              );
            }).toList(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA1D55D),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Back", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? () {
                          setState(() {
                            currentQuestionIndex++;
                          });
                        }
                      : () {
                          if (test == true) {
                            setState(() {
                              test = true;
                              widget.retakeQuiz == false;
                              widget.viewResult ==
                                  true; // Set test to true before submitting
                            });
                          }
                          submitQuiz(); // Call submitQuiz after setting test to true
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA1D55D),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentQuestionIndex < questions.length - 1
                            ? "Next"
                            : "Submit",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        currentQuestionIndex < questions.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
