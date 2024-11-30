import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widget/buildTopButton.dart';
import 'modulesMenu.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/galla_logo.jpeg', // Replace with your logo path
                height: screenHeight * 0.07,
              ),
              BuildTopButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(), // Replace with your screen
                    ),
                  );
                },
                text: 'DashBoard',
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          // SizedBox(height: 24.0),
          LeaderboardEntry(
            rank: '#1',
            userName: 'User Name',
            xp: '100 xp',
            profileImage: 'assets/images/boy.png',
            hatImage: 'assets/icons/crown.svg',
            cupImage: 'assets/icons/gold.svg',
          ),
          LeaderboardEntry(
            rank: '#2',
            userName: 'User Name',
            xp: '80 xp',
            profileImage: 'assets/images/boy.png',
            hatImage: 'assets/icons/partyHat.svg',
            cupImage: 'assets/icons/silver.svg',
          ),
          LeaderboardEntry(
            rank: '#3',
            userName: 'User Name',
            xp: '30 xp',
            profileImage: 'assets/images/boy.png',
            hatImage: 'assets/icons/coolHat.svg',
            cupImage: null,
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry extends StatelessWidget {
  final String rank;
  final String userName;
  final String xp;
  final String profileImage;
  final String hatImage;
  final String? cupImage;

  LeaderboardEntry({
    required this.rank,
    required this.userName,
    required this.xp,
    required this.profileImage,
    required this.hatImage,
    this.cupImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black,
            width: 1.5), // Black border with increased width
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(width: 12.0),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(profileImage),
                radius: 28,
              ),
              Positioned(
                top: -8,
                right: -8,
                child: SvgPicture.asset(
                  hatImage,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ],
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                Text(
                  xp,
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          if (cupImage != null) ...[
            SizedBox(width: 12.0),
            SvgPicture.asset(
              cupImage!,
              width: 28.0,
              height: 28.0,
            ),
          ],
        ],
      ),
    );
  }
}
