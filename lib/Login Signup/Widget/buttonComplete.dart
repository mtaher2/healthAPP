import 'package:flutter/material.dart';

class ButtonComplete extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable to allow disabled state

  const ButtonComplete({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? Colors.grey // Disabled color
              : const Color(0xffA1D55D), // Active color
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed, // Button is disabled if onPressed is null
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mark as Complete',
              style: TextStyle(
                fontSize: 16,
                color: onPressed == null ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8), // Spacing between icon and text
            Icon(
              Icons.check_circle,
              color: onPressed == null ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

