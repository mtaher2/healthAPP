import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Login Signup/Widget/snackbar.dart';

class SummaryReviewPage1_6 extends StatefulWidget {
  const SummaryReviewPage1_6({super.key});

  @override
  _SummaryReviewPage1_6 createState() => _SummaryReviewPage1_6();
}

class _SummaryReviewPage1_6 extends State<SummaryReviewPage1_6> {
  final bool _isConnected = true;
  bool _isLoading = false;
  bool _isComplete = false;
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    _checkCompletionStatus(); // Check completion status on init
  }

  // Function to check if the module is already marked as complete
  Future<void> _checkCompletionStatus() async {
    if (user != null) {
      final userId = user!.uid;
      final firestore = FirebaseFirestore.instance;

      try {
        final doc = await firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            final completedModules = data['completedModules'] as Map?;
            if (completedModules != null) {
              final module1 = completedModules['Module1'] as Map?;
              if (module1 != null) {
                final isComplete = module1['1_6summary'] ?? false;
                print("Module completion status: $isComplete"); // Debugging log
                setState(() {
                  _isComplete = isComplete;
                });
              } else {
                print("Module1 data is null."); // Debugging log
              }
            } else {
              print("CompletedModules data is null."); // Debugging log
            }
          } else {
            print("Document data is null."); // Debugging log
          }
        } else {
          print("Document does not exist."); // Debugging log
        }
      } catch (e) {
        showSnackBar(context, 'Error: $e', Colors.red);
      }
    }
  }

  // Function to mark module as complete and add points
  Future<void> _markModuleAsComplete() async {
    if (!_isConnected) {
      showSnackBar(
          context,
          'No internet connection. Please check your network settings.',
          Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      // Update user's module completion status and add points
      await firestore.collection('users').doc(userId).update({
        'completedModules.Module1.1_6summary': true,
        'score': FieldValue.increment(50),
      });

      // Update the completion status
      setState(() {
        _isComplete = true;
        _isLoading = false;
      });
      showSnackBar(context, '🥳 Module marked as complete and 50 points added!',
          Colors.green);
    } catch (e) {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Error: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Summary and Review',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3058a6),
      ),
      body: _isConnected
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Key Takeaways:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3058a6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildKeyTakeaway(
                      'Ethical principles guide healthcare professionals in making decisions that respect patients\' rights.'),
                  _buildKeyTakeaway(
                      'Beneficence means acting in the best interests of the patient.'),
                  _buildKeyTakeaway(
                      'Justice ensures fair treatment and resource allocation.'),
                  _buildKeyTakeaway(
                      'Non-maleficence is the obligation to avoid causing harm.'),
                  const SizedBox(height: 20),
                  // Add "Mark as Complete" button
                  Align(
                    alignment: Alignment
                        .centerLeft, // Align the button to the start of the page
                    child: IntrinsicWidth(
                      // Make the button only as wide as its content
                      child: ElevatedButton(
                        onPressed: _isComplete || _isLoading
                            ? null
                            : _markModuleAsComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3058a6),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Mark as Complete',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 205, 203, 203)),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                'No internet connection. Please check your network settings.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildKeyTakeaway(String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: const Color(0xFF3058a6), size: screenWidth * 0.06),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),
          ),
        ],
      ),
    );
  }
}
