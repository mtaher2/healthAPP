import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/modulesMenu.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/chatbot.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widget/buildTopButton.dart';
import 'leaderboardScreen.dart';
import 'quizzesAndAssignment.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late Future<Map<String, dynamic>> _userDataFuture;
  final ValueNotifier<double> _valueNotifier = ValueNotifier(60);

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshUserData();
    }
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _userDataFuture = _fetchUserData();
    });
  }

  static Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && !data.containsKey('score')) {
          await userRef.set({'score': 0}, SetOptions(merge: true));
        }

        return {
          'score': data?['score'] ?? 0,
          'name': data?['name'] ?? 'User',
        };
      } else {
        await userRef.set({
          'score': 0,
          'name': 'User',
          'lastUpdate': Timestamp.fromDate(DateTime.now()),
        });
        return {'score': 0, 'name': 'User'};
      }
    }
    return {'score': 0, 'name': 'User'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff509E2D)),
            ));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching user data: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final userXP = snapshot.data?['score'] ?? 0;
            final userName = snapshot.data?['name'] ?? 'User';

            return LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top logo section
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/galla_logo.jpeg',
                                  height:
                                      screenHeight * 0.07, // Responsive height
                                ),
                                BuildTopButton(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeaderboardScreen(),
                                      ),
                                    );
                                  },
                                  text: 'LEADERBOARD',
                                  screenWidth:
                                      screenWidth, // Make sure screenWidth is defined in your context
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          // Profile picture with circular progress
                          Stack(
                            children: [
                              DashedCircularProgressBar.aspectRatio(
                                aspectRatio: 2.6,
                                valueNotifier: _valueNotifier,
                                progress: _valueNotifier.value,
                                startAngle: 225,
                                sweepAngle: 270,
                                foregroundColor: Color(0xff509E2D),
                                backgroundColor: const Color(0xffb7df83),
                                foregroundStrokeWidth: 15,
                                backgroundStrokeWidth: 15,
                                animation: true,
                                seekSize: 0,
                                seekColor: const Color(0xffeeeeee),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage:
                                        AssetImage('assets/images/boy.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Image.asset(
                            'assets/icons/banana.png',
                            width: screenWidth * 0.08,
                            height: screenWidth * 0.08,
                          ),
                          // XP and user name
                          Text(
                            '$userXP XP',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              color: Color(0xff12284F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Color(0xff12284F),
                            ),
                          ),
                          SizedBox(height: 10),
                          BuildTopButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModulesPage(),
                                ),
                              );
                            },
                            text: 'CHANGE USER',
                            screenWidth:
                                screenWidth, // Make sure screenWidth is defined in your context
                          ),

                          SizedBox(height: 20),
                          // Horizontal progress bar with icons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(15),
                                    value: 0.8,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xff509E2D)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildIcon('banana.png', screenWidth),
                                        _buildIcon('partyHat.png', screenWidth),
                                        _buildIcon('red_hat.png', screenWidth),
                                        _buildIcon('coolHat.png', screenWidth),
                                        _buildIcon('crown.png', screenWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          // Image buttons for modules, quizzes, announcements
                          _buildImageButton('assets/images/modules.png',
                              'MODULES', context, screenWidth),
                          _buildImageButton('assets/images/quiz.png',
                              'quizzes & assignments', context, screenWidth),
                          _buildImageButton('assets/images/announcement.png',
                              'announcements', context, screenWidth),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    BuildChatBotWithCurvedLines(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaderboardScreen(),
                            ),
                          );
                        },
                        screenWidth: screenWidth)
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildImageButton(String imagePath, String label, BuildContext context,
      double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          if (label == 'MODULES') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ModulesPage()),
            );
          } else if (label == 'quizzes & assignments') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizAssignmentScreen()),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 109,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: 109,
              color: Colors.black.withOpacity(0.4),
            ),
            Text(
              textAlign: TextAlign.center,
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.08, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath, double screenWidth) {
    return Image.asset(
      'assets/icons/$iconPath',
      height: screenWidth * 0.06, // Responsive icon height
    );
  }
}
