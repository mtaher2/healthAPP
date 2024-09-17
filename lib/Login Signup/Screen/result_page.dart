import 'package:flutter/material.dart';
import '../Services/QuizQuestion .dart';
import 'quiz_page.dart'; // Import the quiz page
import 'home_screen.dart'; // Import the home screen

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<QuizQuestion> quizQuestions;
  final String quizTitle; // Add this field to show the quiz title

  ResultPage({
    required this.score,
    required this.totalQuestions,
    required this.quizQuestions,
    required this.quizTitle, // Initialize the field
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('$quizTitle',
        style: TextStyle(
          color: Colors.white,
        ),
        ), // Display the quiz title
        backgroundColor: Color(0xFF3058a6),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You scored $score out of $totalQuestions!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3058a6),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      questions: quizQuestions,
                      quizId: quizTitle, // Pass the same quiz ID for restarting
                    ),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
              child: Text('Restart Quiz',
              style: TextStyle(
                color: Colors.white,
              ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3058a6),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
              child: Text('Back to Home',
              style: TextStyle(
                color: Colors.white,
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
