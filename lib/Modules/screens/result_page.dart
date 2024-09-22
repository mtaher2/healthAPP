import 'package:flutter/material.dart';
import '../Services/QuizQuestion .dart';
import '../widgets/quiz_page.dart'; // Import the quiz page
import '../../Login Signup/Screen/home_screen.dart'; // Import the home screen

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
        backgroundColor: Color(0xFF3058a6),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          '$quizTitle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ), // Display the quiz title
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'You scored $score out of $totalQuestions!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3058a6),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage(
                              questions: quizQuestions,
                              quizId:
                                  quizTitle, // Pass the same quiz ID for restarting
                            ),
                          ),
                          (route) => false, // Remove all previous routes
                        );
                      },
                      child: Text(
                        'Restart Quiz',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3058a6),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false, // Remove all previous routes
                        );
                      },
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
}
