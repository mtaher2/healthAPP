import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import for Firestore
import 'package:flutter_firebase_project/Login%20Signup/Widget/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            myDialogBox(context);
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff4771f5),
            ),
          ),
        ),
      ),
    );
  }

  void myDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    const Text(
                      "Forgot Your Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter the Email",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    // Validate email field is not empty
                    if (emailController.text.isEmpty) {
                      showSnackBar(context, "Please enter a valid email address.", Colors.red);
                      return;
                    }

                    String email = emailController.text.trim().toLowerCase();

                    try {
                      // Check if email exists in Firestore
                      final userDoc = await firestore.collection('users')
                          .where('email', isEqualTo: email)
                          .get();

                      if (userDoc.docs.isEmpty) {
                        // Email does not exist in Firestore
                        showSnackBar(context, "No user found with this email.", Colors.red);
                      } else {
                        // Email exists, proceed to send the reset password link
                        await auth.sendPasswordResetEmail(email: email);
                        showSnackBar(context, "We have sent you a reset password link to your email. Please check it.", Colors.green);
                        Navigator.pop(context); // Close the dialog
                      }
                    } on FirebaseAuthException catch (e) {
                      // Handle specific FirebaseAuth exceptions
                      if (e.code == 'user-not-found') {
                        showSnackBar(context, "No user found with this email.", Colors.red);
                      } else if (e.code == 'invalid-email') {
                        showSnackBar(context, "The email address is invalid.", Colors.red);
                      } else {
                        showSnackBar(context, "Error: ${e.message}", Colors.red);
                      }
                    } catch (e) {
                      // Handle general exceptions
                      showSnackBar(context, "An error occurred. Please try again later.", Colors.red);
                    }

                    // Clear the text field after the process
                    emailController.clear();
                  },
                  child: const Text(
                    "Send",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
