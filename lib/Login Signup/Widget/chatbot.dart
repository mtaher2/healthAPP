import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildChatBotWithCurvedLines extends StatelessWidget {
  final VoidCallback onTap;
  final double screenWidth;

  const BuildChatBotWithCurvedLines({
    Key? key,
    required this.onTap,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // SVG image at the bottom
        Positioned(
          bottom: -19,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/images/curved_lines.svg',
            width: screenWidth, // Use screenWidth parameter
            fit: BoxFit.cover,
          ),
        ),
        // Chat bot icon button positioned slightly above the SVG on the left
        Positioned(
          bottom: 10,
          right: 25,
          child: ElevatedButton(
            onPressed: onTap, // Trigger onTap callback
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
              elevation: 4,
            ),
            child: SvgPicture.asset(
              'assets/icons/chatbot.svg',
              width: 80,
              height: 80,
            ),
          ),
        ),
      ],
    );
  }
}
