import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Register user with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await cred.user?.sendEmailVerification();

        // Add user to Firestore database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success";
      } else {
        res = "Please provide all fields";
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (e.code == 'email-already-in-use') {
        res = "The email address is already in use by another account.";
      } else if (e.code == 'weak-password') {
        res = "The password provided is too weak.";
      } else {
        res = e.message ?? "An unknown error occurred.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload(); // Reload user to get the latest status
    return user?.emailVerified ?? false;
  }

Future<String> loginUser({
  required String email,
  required String password,
}) async {
  String res = "Some error occurred";
  try {
    if (email.isNotEmpty && password.isNotEmpty) {
      // Log in user with email and password
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (cred.user?.emailVerified ?? false) {
        res = "success";
      } else {
        res = "Email not verified. Please check your inbox.";
        await _auth.signOut(); // Sign out the user if email is not verified
      }
    } else {
      res = "Please enter all fields.";
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase authentication errors
    switch (e.code) {
      case 'user-not-found':
        res = "No user found with this email.";
        break;
      case 'wrong-password':
        res = "Incorrect password. Please try again.";
        break;
      case 'invalid-email':
        res = "The email address is invalid.";
        break;
      case 'user-disabled':
        res = "The user account has been disabled.";
        break;
      case 'too-many-requests':
        res = "Too many unsuccessful login attempts. Please try again later.";
        break;
      case 'operation-not-allowed':
        res = "Operation not allowed. Please enable the sign-in method in your Firebase console.";
        break;
      case 'auth/invalid-credential':
        res = "The supplied credentials are malformed.";
        break;
      case 'auth/credential-too-old':
        res = "The supplied credentials are incorrect or expired.";
        break;
      default:
        res = "Wrong email or password.";
        break;
    }
  } catch (err) {
    res = "An error occurred. Please try again later.";
  }
  return res;
}



  Future<void> signOut() async {
    await _auth.signOut();
  }
}
