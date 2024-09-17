import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/QuizQuestion .dart';
import 'result_page.dart'; // Ensure this page is created

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String quizId;
  QuizPage({required this.questions, required this.quizId});

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
            duration: Duration(milliseconds: 300),
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
    await _storeQuizResults();
    if (mounted) {
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

  Future<void> _storeQuizResults() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Store only the latest quiz result
      await userDoc.set({
        widget.quizId: {
          'score': _score,
          'totalQuestions': widget.questions.length,
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF3058a6),
        title: Text(
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
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xfff6f2f1),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 8, // The softness of the shadow
                      offset: Offset(
                          0, 4), // Horizontal and vertical offset of the shadow
                    ),
                  ],
                ),
                child: Text(
                  currentQuestion.scenario,
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Text(
                currentQuestion.question,
                style: TextStyle(
                    fontSize: screenWidth * 0.05, color: Color(0xFF3058a6)),
              ),
              SizedBox(height: 20),
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
                  activeColor: Color(0xFF3058a6),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3058a6),
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
                    color: Color(0xFF3058a6),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3058a6),
                  ),
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentQuestionIndex < widget.questions.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz',
                    style: TextStyle(color: Colors.white),
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
