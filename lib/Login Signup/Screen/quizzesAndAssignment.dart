import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../Widget/buildTopButton.dart';
import '../Widget/chatbot.dart';
import 'LeaderboardScreen.dart';
import 'ErrorPageScreen.dart';
import 'home_screen.dart';

class QuizAssignmentScreen extends StatefulWidget {
  @override
  _QuizAssignmentScreenState createState() => _QuizAssignmentScreenState();
}

class _QuizAssignmentScreenState extends State<QuizAssignmentScreen> {
  final String quizImagePath = 'assets/images/quiz.svg';
  final String quizFinishedImagePath = 'assets/images/FinishQuiz.svg';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, bool> quizCompletionStatus = {};
  List<String> quizzes = [];
  List<String> assignments = [];
  bool isLoading = true;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  Future<void> _checkInternetConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ErrorPageScreen()),
      );
    } else {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (user != null) {
      final moduleDoc = await _firestore
          .collection('Modules')
          .doc('AINc83uOgA8i1W1quLgy')
          .get();
      quizzes = List<String>.from(moduleDoc.data()?['quizzes'] ?? []);
      assignments = List<String>.from(moduleDoc.data()?['assignment'] ?? []);

      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      final quizGrades = userDoc.data()?['quiz_grades'] ?? {};

      setState(() {
        for (String quiz in quizzes) {
          quizCompletionStatus[quiz] = quizGrades[quiz]?['score'] != null;
        }
        isLoading = false;
      });
    }
  }

  void _showQuizDialog(String quizKey) async {
    bool isCompleted = quizCompletionStatus[quizKey] ?? false;
    String quizStatusText = isCompleted ? 'take it again' : 'take quiz';
    String quizDetails = isCompleted
        ? 'quiz details ........................................ \ntaken'
        : 'quiz details ........................................ \nnot taken yet';

    // Initialize scoreText with a default value
    String scoreText = '5 points';

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing until data is loaded
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 20, // Adjust width as needed
            height: 20, // Adjust height as needed
            child: CircularProgressIndicator(
              strokeWidth: 4.0, // Adjust the thickness of the indicator
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff509E2D)),
            ),
          ),
        );
      },
    );

    // Fetch data from Firestore
    if (user != null) {
      // Initialize userScore as null
      dynamic userScore = null;

      // Fetch user document from Firestore
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();

      // Check if quiz_grades and quizKey exist in the user's data
      if (userDoc.data()?['quiz_grades'] != null &&
          userDoc.data()?['quiz_grades'][quizKey] != null) {
        userScore = userDoc.data()?['quiz_grades'][quizKey]['score'];
      }

      // Fetch max grade for the quiz from Modules collection
      final moduleDoc = await _firestore
          .collection('Modules')
          .doc('AINc83uOgA8i1W1quLgy')
          .get();
      final maxGrade = moduleDoc.data()?['grades']?[quizKey] ?? 5;

      // Update scoreText based on whether the quiz is completed
      scoreText = isCompleted
          ? '${userScore ?? 0}/$maxGrade' // Display user's score and max grade
          : '$maxGrade points'; // Display max grade if not taken
    }

    // Close the loading dialog
    Navigator.pop(context);

    // Show the quiz dialog with fetched data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                padding:
                    EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xffA1D55D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quizKey,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          scoreText,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      quizDetails,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff1F3D83),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          Navigator.pushNamed(context, '/quizscreen/$quizKey');
                        },
                        child: Text(
                          quizStatusText,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff097CBF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.zero, // No rounded corners
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff509E2D)),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/galla_logo.jpeg',
                                height: screenHeight * 0.07,
                              ),
                              BuildTopButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                },
                                text: 'DashBoard',
                                screenWidth: screenWidth,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Quizzes',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff14259B),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: screenWidth > 600 ? 4 : 3,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            String quizKey = 'quiz${index + 1}';
                            bool isCompleted =
                                quizCompletionStatus[quizKey] ?? false;

                            return GestureDetector(
                              onTap: () {
                                _showQuizDialog(quizKey);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    isCompleted
                                        ? quizFinishedImagePath
                                        : quizImagePath,
                                    width: 60,
                                    height: 60,
                                  ),
                                  Positioned(
                                    top: 55,
                                    child: Text(
                                      'Q${index + 1}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 30,
                          color: Color(0xff14259B),
                        ),
                        Text(
                          'Assignments',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff14259B),
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: assignments.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Handle assignment button click here
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(assignments[index]),
                                  trailing: Text(
                                    '20 points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: 85,
                  child: BuildChatBotWithCurvedLines(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardScreen(),
                        ),
                      );
                    },
                    screenWidth: screenWidth,
                  ),
                ),
              ],
            ),
    );
  }
}
