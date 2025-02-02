import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screen/QuizPage.dart';

class QuizDialog extends StatefulWidget {
  final String quizKey;

  const QuizDialog({Key? key, required this.quizKey}) : super(key: key);

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  bool isCompleted = false;
  int attemptCount = 0;
  int maxAttempts = 2;
  String scoreText = '';
  String quizDetails = '';
  int? allowAttempt; // Variable to store the fetched allowAttempt value

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      final quizzesCollection = userDoc.reference.collection('quizzes');
      final quizDoc = await quizzesCollection.doc(widget.quizKey).get();

      if (quizDoc.exists) {
        final firstAttemptScore = quizDoc.data()?['firstAttempt']?['score']; // First attempt score
        final secondAttemptScore = quizDoc.data()?['secondAttempt']?['score']; // Second attempt score
        final attempts = quizDoc.data()?['attemptCount'] ?? 0;
        allowAttempt = quizDoc.data()?['allowAttempt'];

        final moduleDoc = await _firestore
            .collection('Modules')
            .doc('AINc83uOgA8i1W1quLgy')
            .get();
        final maxGrade = moduleDoc.data()?['grades']?[widget.quizKey] ?? 5;

        setState(() {
          attemptCount = attempts;
          if (allowAttempt == null) {
            quizDetails = 'Quiz not taken yet';
          } else if (allowAttempt == 1) {
            quizDetails = 'First Attempt Score: $firstAttemptScore'; // Display first attempt score
            scoreText = firstAttemptScore != null ? '$firstAttemptScore/$maxGrade' : '$maxGrade points';
          } else if (allowAttempt == 0) {
            // Compare the first and second attempt scores
            int highestScore = firstAttemptScore != null && secondAttemptScore != null
                ? (firstAttemptScore > secondAttemptScore ? firstAttemptScore : secondAttemptScore)
                : (firstAttemptScore ?? secondAttemptScore ?? 0);
            quizDetails = 'Highest Score: $highestScore'; // Show highest score
            scoreText = '$highestScore/$maxGrade';
          }
          isCompleted = firstAttemptScore != null || secondAttemptScore != null;
          isLoading = false;
        });
      } else {
        setState(() {
          isCompleted = false;
          attemptCount = 0;
          scoreText = '0';
          quizDetails = 'Quiz not taken yet';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the dialog when tapping outside
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff509E2D)),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffA1D55D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.quizKey,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                scoreText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            quizDetails,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff1F3D83),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: _buildButtons(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (allowAttempt == null) {
      // If allowAttempt is null (user has not attempted yet), show "Take Quiz" and display attempts as 2
      return Column(
        children: [
          Text(
            'Remaining Attempts: $maxAttempts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(quizName: widget.quizKey),
                ),
              );
            },
            child: Text(
              'Take quiz',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff097CBF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      );
    } else if (allowAttempt == 1) {
      // If allowAttempt = 1, show "Take Quiz Again" and "View Results"
      return Column(
        children: [
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    quizName: widget.quizKey,
                    retakeQuiz: true,
                  ),
                ),
              );
            },
            child: Text(
              'Take it again',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff097CBF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      );
    } else if (allowAttempt == 0) {
      // If allowAttempt = 0, show "View Results" only
      return ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                quizName: widget.quizKey,
                viewResult: true,
                retakeQuiz: false,
              ),
            ),
          );
        },
        child: Text(
          'View Results',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff097CBF),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
