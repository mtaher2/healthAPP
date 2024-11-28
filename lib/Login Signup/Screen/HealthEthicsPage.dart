import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login.dart';
import 'signup.dart';

class HealthEthicsPage extends StatelessWidget {
  const HealthEthicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Content (SVG Image and Logo)
          Column(
            children: [
              // Top Logos
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.04,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/galla_logo.jpeg', // Replace with your image path
                    height:
                        screenHeight * 0.05, // Scale height relative to screen
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Doctor SVG
              SvgPicture.asset(
                'assets/images/doctor_welcome.svg', // Replace with your SVG path
                width: screenWidth * 0.6, // Scale width relative to screen
              ),
            ],
          ),

          // Green Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.438, // Scale height relative to screen
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF92D050), // Green color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(58), // Top-left rounded corner
                  topRight: Radius.circular(58), // Top-right rounded corner
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Let's begin your learning journey",
                      style: TextStyle(
                        fontSize: 20, // Font size remains consistent
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF12284F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Log In Button
                    SizedBox(
                      width:
                          double.infinity, // Stretch button to container width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF097CBF),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded edges
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white), // Match font size
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Sign Up Button
                    SizedBox(
                      width:
                          double.infinity, // Stretch button to container width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFFFFFFF),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded edges
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0XFF097CBF)), // Match font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
