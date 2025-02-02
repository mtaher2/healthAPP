import 'package:flutter/material.dart';
import '../Screen/leaderboardScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              // Background SVG image
              Positioned(
                bottom: -19,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/curved_lines.svg',
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
              ),
              // Chat bot icon button
              Positioned(
                bottom: 10,
                right: 25,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardScreen(),
                      ),
                    );
                  },
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
        },
      ),
    );
  }
}