import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final Duration _cooldownDuration = const Duration(seconds: 60);
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = _cooldownDuration.inSeconds;
      _isButtonDisabled = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isButtonDisabled = false;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    if (_secondsRemaining > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please wait until the countdown finishes to resend the verification email.',
          ),
        ),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email resent.')),
        );
        _startCountdown();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to send verification email: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('User is already verified or not available.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/images/galla_logo.jpeg', // Replace with the actual path to your logo
                  width: 130,
                  height: 50,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SvgPicture.asset(
              'assets/images/email.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 30.0), // Adjust padding for the text
              child: Text(
                'a verefication email have been send to you ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff12284F),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0), // Add padding here too
              child: Text(
                'Please check your inbox and click on the verification link to activate your account.',
                style: TextStyle(
                  fontSize: 17.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: screenWidth * 0.9, // 90% of the screen width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA1D55D),
                ),
                child: const Text('Back to Login',
                style: TextStyle(
                  color: Colors.black,
                ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.9, // 90% of the screen width
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        resendVerificationEmail(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonDisabled
                      ? const Color(0xFFcce8a6)
                      : const Color(0xFFA1D55D),
                ),
                child: Text(
                  style: const TextStyle(
                  color: Colors.black,
                ),
                  _isButtonDisabled
                      ? 'Try again after $_secondsRemaining seconds'
                      : 'Resend Email Verification',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
