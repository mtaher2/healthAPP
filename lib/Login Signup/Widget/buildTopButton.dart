import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/modulesMenu.dart';

class BuildTopButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double screenWidth;

  const BuildTopButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 30,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffA1D55D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
