import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/home_screen.dart';

// Ensure you import all required pages
import '../../Modules/screens/Module1/1.1_Overview.dart'; // Ensure this file contains `HealthcareEthicsPage`
import '../../Modules/screens/Module1/1.2_HistoricalContextOfHealthcareEthics.dart'; // Ensure this file contains `HistoricalContextPage1_2`
import '../../Modules/screens/Module1/1.3_EthicalPrinciples.dart'; // Ensure this file contains `EthicalPrinciplesPage`
import '../../Modules/screens/Module1/1.4_Podcast.dart';
import '../../Modules/screens/Module1/1.5_CaseStudies.dart'; // Ensure this file contains `InstructionsPage1_5`
import '../../Modules/screens/Module1/1.6_SummaryReviewPage.dart';
import '../Widget/buildTopButton.dart'; // Ensure this file contains `SummaryReviewPage1_6`

class ModulePage extends StatefulWidget {
  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11),
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
                      builder: (context) =>
                          HomeScreen(), // Replace with your screen
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Module buttons
              SizedBox(
                height: 10,
              ),
              ModuleWidget(
                moduleName: "Module 1",
                items: [
                  ModuleItem(
                      icon: Icons.play_circle_fill,
                      title: "Video Lecture",
                      color: Colors.red,
                      targetPage:HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.description,
                      title: "Lecture Notes",
                      color: Colors.grey,
                      targetPage: HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.assignment,
                      title: "Assignment",
                      color: Colors.orange,
                      targetPage: HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.quiz, 
                      title: "Quiz", 
                      color: Colors.brown,
                      targetPage: HistoricalContextPage1_2()),
                ],
              ),
              SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 2",
                items: [
                  ModuleItem(
                      icon: Icons.video_library,
                      title: "New Video Content",
                      color: Colors.blue,
                      targetPage: HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.notes,
                      title: "Special Notes",
                      color: Colors.green,
                      targetPage: HistoricalContextPage1_2()),
                ],
              ),
              SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 3",
                items: [
                  ModuleItem(
                      icon: Icons.book,
                      title: "Reading Material",
                      color: Colors.purple,
                      targetPage: HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.assignment_late,
                      title: "Pending Tasks",
                      color: Colors.red,
                      targetPage: HistoricalContextPage1_2()),
                ],
              ),
              SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 4",
                items: [
                  ModuleItem(
                      icon: Icons.video_call,
                      title: "Live Session",
                      color: Colors.teal,
                      targetPage: HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.feedback,
                      title: "Feedback Form",
                      color: Colors.amber,
                      targetPage: HistoricalContextPage1_2()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable ModuleWidget
class ModuleWidget extends StatefulWidget {
  final String moduleName;
  final List<ModuleItem> items;

  ModuleWidget({required this.moduleName, required this.items});

  @override
  _ModuleWidgetState createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0XFFA1D55D),
              border: Border.all(color: Colors.black, width: 2),
            ),
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.moduleName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0),
              ),
            ),
            child: Column(
              children: widget.items.map((item) => buildListItem(item)).toList(),
            ),
          ),
      ],
    );
  }

  Widget buildListItem(ModuleItem item) {
    return ListTile(
      leading: Icon(item.icon, color: item.color),
      title: Text(item.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => item.targetPage, // Directly navigate to the target page
          ),
        );
      },
    );
  }
}


// ModuleItem class to define items in the dropdown
class ModuleItem {
  final IconData icon;
  final String title;
  final Color color;
  final Widget targetPage; // Add this to hold the page

  ModuleItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.targetPage, // Accept the target page as a parameter
  });
}

