import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class ScenarioPage extends StatefulWidget {
  @override
  _ScenarioPageState createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  final TextEditingController _answerController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _submittedAnswer;
  DateTime? _submissionDate; // To store the submission date
  bool _isAnswerSubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSubmission();
  }

Future<void> _checkExistingSubmission() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        print("Firestore data: $data"); // Debug print to show all document data
        
        if (data != null && data.containsKey('1.5_sensitive topic')) {
          setState(() {
            _submittedAnswer = data['1.5_sensitive topic']['answer'];
            _isAnswerSubmitted = _submittedAnswer != null;

            // Fetch and store the timestamp as a DateTime object
            if (data['1.5_sensitive topic'].containsKey('timestamp')) {
              Timestamp? timestamp = data['1.5_sensitive topic']['timestamp'];
              if (timestamp != null) {
                _submissionDate = timestamp.toDate(); // Convert timestamp to DateTime
                print("Submission date: $_submissionDate\n\n\n\n\n");
              } else {
                print("Timestamp is null.");
              }
            } else {
              print("No timestamp found in Firestore.");
            }

            _answerController.text = _submittedAnswer ?? '';
          });
        }
      }
    } catch (e) {
      print("Error checking submission: $e");
    }
  }
}



  Future<void> _storeScenarioAnswer(String answer) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          '1.5_sensitive topic': {
            'answer': answer,
            'timestamp': FieldValue.serverTimestamp(),
          }
        }, SetOptions(merge: true));
      } catch (e) {
        print("Error storing answer: $e");
      }
    }
  }

  Future<void> _submitAnswer() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to submit an answer!')),
      );
      return;
    }

    final answer = _answerController.text;
    if (answer.isNotEmpty) {
      await _storeScenarioAnswer(answer);
      setState(() {
        _isAnswerSubmitted = true;
        _submittedAnswer = answer;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answer submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answer cannot be empty!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Format the submission date if it exists
    String formattedDate = _submissionDate != null
        ? DateFormat('MMMM d, yyyy, h:mm a').format(_submissionDate!)
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3058a6),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Scenario-Based Question',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Color(0xfff6f2f1),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "A transgender patient has come to you for treatment, and during the course of care, they disclose their gender identity to you in confidence. However, their medical records still list their assigned gender at birth, and other healthcare providers involved in their care are unaware of the patient’s gender identity. What ethical challenges might arise in maintaining the patient’s confidentiality while ensuring they receive appropriate and respectful care? How would you navigate this situation to balance the ethical principles of confidentiality, respect for patient autonomy, and effective communication within the healthcare team?",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Your Answer',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF3058a6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF3058a6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF3058a6)),
                  ),
                ),
                maxLines: 5,
                readOnly: _isAnswerSubmitted, // Disable text field if answer is submitted
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3058a6), // Primary color
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _isAnswerSubmitted ? null : _submitAnswer, // Disable button if answer is submitted
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              if (_submittedAnswer != null)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Text(
                    'Submitted on: $formattedDate',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
