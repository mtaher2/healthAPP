import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/snackbar.dart';
import '../Services/QuizQuestion .dart';
import '../screens/result_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String quizId;
  const QuizPage({super.key, required this.questions, required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _isAnswered = false;
  bool _isLoading = false; // New loading state
  final ScrollController _scrollController = ScrollController();

  void _submitAnswer() {
    setState(() {
      if (_selectedOption != null && !_isAnswered) {
        _isAnswered = true;
        _showFeedback = true;
        _isCorrect = _selectedOption ==
            widget.questions[_currentQuestionIndex].correctAnswerIndex;
        if (_isCorrect) {
          _score++;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _showFeedback = false;
        _isAnswered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Check internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      // Show an error message if there's no internet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No internet connection. Please try again later.')),
      );
      return;
    }

    try {
      await _storeQuizResults();
    } catch (e) {
      // Handle error (e.g., show a message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to save results. Please try again later.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: _score,
              totalQuestions: widget.questions.length,
              quizQuestions: widget.questions,
              quizTitle: widget.quizId,
            ),
          ),
        );
      }
    }
  }

Future<void> _storeQuizResults() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Fetch existing user data
    DocumentSnapshot userSnapshot = await userDoc.get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    // Calculate percentage score
    double percentageScore = (_score / widget.questions.length) * 100;

    // Check if the user has already submitted this quiz
    bool isFirstSubmission =
        userData == null || !userData.containsKey(widget.quizId);

    if (isFirstSubmission) {
      // Handle first-time submission
      if (percentageScore > 50) {
        // Add 50 points to the score
        await userDoc.set({
          widget.quizId: {
            'score': _score,
            'totalQuestions': widget.questions.length,
            'timestamp': FieldValue.serverTimestamp(),
          }
        }, SetOptions(merge: true));

        int currentScore = userData?['score'] ?? 0;
        await userDoc.update({
          'score': currentScore + 50,
        });

        // Show a snackbar to inform the user about the bonus points
        if (mounted) {
          showSnackBar(
              context,
              '🥳 Congratulations! 50 points have been added to your score.',
              Colors.green);
        }
      } else {
        // Show snackbar if the score is 50% or less
        if (mounted) {
          showSnackBar(
              context,
              '😓 You must score more than 50% to receive bonus points.',
              Colors.red);
        }
      }
    } else {
      // Handle subsequent submissions
      double previousScorePercentage = (userData[widget.quizId]['score'] ?? 0) / widget.questions.length * 100;

      // Update quiz result without changing the score if it's not the first submission
      await userDoc.set({
        widget.quizId: {
          'score': _score,
          'totalQuestions': widget.questions.length,
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      // Compare and update score if necessary
      if (percentageScore > 50 && previousScorePercentage <= 50) {
        int currentScore = userData['score'] ?? 0;
        await userDoc.update({
          'score': currentScore + 50,
        });

        // Show a snackbar to inform the user about the bonus points
        if (mounted) {
          showSnackBar(
              context,
              '🥳 Congratulations! 50 points have been added to your score.',
              Colors.green);
        }
      } else if (percentageScore <= 50 && previousScorePercentage > 50) {
        // If the new score is less than or equal to 50% but previous score was greater than 50%
        // Keep the previous higher score
        await userDoc.update({
          widget.quizId: {
            'score': userData[widget.quizId]['score'],
            'totalQuestions': widget.questions.length,
            'timestamp': FieldValue.serverTimestamp(),
          }
        });
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final correctAnswer =
        currentQuestion.options[currentQuestion.correctAnswerIndex];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const  Color(0xFF3058a6),
        title: const Text(
          'Quiz',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: 16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xfff6f2f1),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  currentQuestion.scenario,
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentQuestion.question,
                style: TextStyle(
                    fontSize: screenWidth * 0.05, color: const Color(0xFF3058a6)),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                currentQuestion.options.length,
                (index) => RadioListTile<int>(
                  title: Text(
                    currentQuestion.options[index],
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  activeColor:const Color(0xFF3058a6),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3058a6),
                ),
                onPressed: _isAnswered ? null : _submitAnswer,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_showFeedback) ...[
                const SizedBox(height: 20),
                Text(
                  _isCorrect ? 'Correct!' : 'Incorrect.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  'Correct Answer: $correctAnswer',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rationale: ${currentQuestion.rationale}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF3058a6),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading // Show loading indicator if _isLoading is true
                    ? const Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF3058a6)),
                      ))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3058a6),
                        ),
                        onPressed: _nextQuestion,
                        child: Text(
                          _currentQuestionIndex < widget.questions.length - 1
                              ? 'Next Question'
                              : 'Finish Quiz',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
