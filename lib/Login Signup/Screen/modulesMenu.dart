import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/home_screen.dart';

// Ensure you import all required pages
import '../../Modules/screens/Module1/1.1_Overview.dart'; // Ensure this file contains `HealthcareEthicsPage`
import '../../Modules/screens/Module1/1.2_HistoricalContextOfHealthcareEthics.dart'; // Ensure this file contains `HistoricalContextPage1_2`
import '../../Modules/screens/Module1/1.3_EthicalPrinciples.dart'; // Ensure this file contains `EthicalPrinciplesPage`
import '../../Modules/screens/Module1/1.4_Podcast.dart';
import '../../Modules/screens/Module1/1.5_CaseStudies.dart'; // Ensure this file contains `InstructionsPage1_5`
import '../../Modules/screens/Module1/1.6_SummaryReviewPage.dart'; // Ensure this file contains `SummaryReviewPage1_6`

class ModulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modules", 
        style: TextStyle(
          color: Colors.white,
        ),
        ),
        backgroundColor: const Color(0xFF3058a6),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back), // You can change this to any icon you prefer
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: [
            buildModuleTile(context, 'Module 1', [
              'Overview of Ethics in Healthcare',
              'Historical Context of Healthcare Ethics',
              'Ethical Principles in Healthcare',
              'Ethical Vulnerability in Healthcare',
              'Case Studies and Scenarios',
              'Summary and Review',
            ]),
            buildModuleTile(context, 'Module 2', [
              'Patient Rights in Healthcare',
              'Doctor-Patient Relationship (Types and Communication Styles)',
              'Core Communication Skills with the Patient',
            ]),
            buildModuleTile(context, 'Module 3', [
              'Advanced Communication Skills',
              'Breaking Bad News',
              'How to Deal with Difficult Situations and Personalities',
            ]),
            buildModuleTile(context, 'Module 4', [
              'Identifying Ethical Dilemmas',
              'Steps in Ethical Decision-Making',
              'The Ethical Dilemma',
              'Steps to Solve the Ethical Dilemma Using the Four-Box Method and DECIDE Model',
              'Conclusion',
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildModuleTile(
      BuildContext context, String moduleTitle, List<String> topics) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ExpansionTile(
          title: Text(
            moduleTitle,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width *
                  0.05, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          children: topics
              .map((topic) => ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Text(
                      topic,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.04), // Responsive font size
                    ),
                    onTap: () {
                      // Adjust navigation based on the topic
                      switch (topic) {
                        case 'Overview of Ethics in Healthcare':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthcareEthicsPage()),
                          );
                          break;
                        case 'Historical Context of Healthcare Ethics':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HistoricalContextPage1_2()),
                          );
                          break;
                        case 'Ethical Principles in Healthcare':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EthicalPrinciplesPage()),
                          );
                          break;
                        case 'Ethical Vulnerability in Healthcare':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnhancedAudioPlayerPage()),
                          );
                          break;
                        case 'Case Studies and Scenarios':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstructionsPage1_5()),
                          );
                          break;
                        case 'Summary and Review':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SummaryReviewPage1_6()),
                          );
                          break;
                        default:
                          print('No page defined for $topic');
                          break;
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
