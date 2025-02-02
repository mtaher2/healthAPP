import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final bool isNext; // Determines if the button is "Next" or "Back"
  final VoidCallback onPressed;

  const NavigationButton({
    required this.isNext,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffA1D55D), // Custom background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Adjust button size to fit content
        children: [
          if (!isNext) // Add back icon for "Back" button
            const Icon(Icons.arrow_back, color: Colors.black),
          if (!isNext) const SizedBox(width: 8), // Spacing for "Back" icon
          Text(
            isNext ? 'Next' : 'Back', // Display appropriate label
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          if (isNext) const SizedBox(width: 8), // Spacing for "Next" icon
          if (isNext) // Add forward icon for "Next" button
            const Icon(Icons.arrow_forward, color: Colors.black),
        ],
      ),
    );
  }
}
