import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final Duration _cooldownDuration = Duration(seconds: 60);
  Timer? _timer;
  int _secondsRemaining = 0; // Countdown time in seconds
  bool _isButtonDisabled = false; // Track if the resend button is disabled

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Start countdown when the page is created
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = _cooldownDuration.inSeconds;
      _isButtonDisabled = true; // Disable button during countdown
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isButtonDisabled = false; // Enable button once countdown finishes
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    // Check if the cooldown is still active
    if (_secondsRemaining > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        _startCountdown(); // Start countdown after resending the email
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 100,
              color: Color(0xff2b8299),
            ),
            const SizedBox(height: 20),
            const Text(
              'A verification email has been sent to your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please check your inbox and click on the verification link to activate your account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back to Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      resendVerificationEmail(context);
                    },
              child: Text(
                _isButtonDisabled
                    ? 'Try again in $_secondsRemaining seconds'
                    : 'Resend Email Verification',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
