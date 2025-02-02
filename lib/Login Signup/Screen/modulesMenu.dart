import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Screen/home_screen.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/descriptionPage.dart';

// Ensure you import all required pages
import '../../Modules/screens/Module1/1.1_Overview.dart'; // Ensure this file contains `HealthcareEthicsPage`
import '../../Modules/screens/Module1/1.2_HistoricalContextOfHealthcareEthics.dart'; // Ensure this file contains `HistoricalContextPage1_2`
import '../../Modules/screens/Module1/1.3_EthicalPrinciples.dart'; // Ensure this file contains `EthicalPrinciplesPage`
import '../../Modules/screens/Module1/1.4_Podcast.dart';
import '../../Modules/screens/Module1/1.5_CaseStudies.dart'; // Ensure this file contains `InstructionsPage1_5`
import '../../Modules/screens/Module1/1.6_SummaryReviewPage.dart';
import '../../Modules/widgets/quiz_page.dart';
import '../Widget/buildTopButton.dart';
import '../Widget/quiz_dialog.dart';
import '../Widget/videoPage.dart';
import 'QuizPage.dart'; // Ensure this file contains `SummaryReviewPage1_6`

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
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
              const SizedBox(
                height: 10,
              ),
              ModuleWidget(
                  moduleName: "Health Ethics Related Concepts",
                  items: [
                    ModuleItem(
                      icon: Icons.notes,
                      title: "Learning Objectives",
                      color: Colors.green,
                      targetPage: const HealthcareEthicsPage(),
                    ),
                    ModuleItem(
                      icon: Icons.description,
                      title: "Caring: Definition",
                      color: Colors.grey,
                      targetPage: ImagePage(
                        svgImagePath: "CaringDefinition.png",
                        modulePath: "Module0.CaringDefinition",
                        descriptionText:
                            "Caring refers to showing concern for and attending to the needs of others, particularly in healthcare, where it involves compassion and dedication to the well-being of patients.",
                        nextPage: VideoPage(
                          youtubeLink:
                              "https://www.youtube.com/watch?v=wkf-WxMZVP8",
                          modulePath: "Module0.caringVideo",
                          descriptionText:
                              "The video begins with a patient in palliative care who is in pain. The patient is receiving IV access, and the staff is working to manage their pain and provide them with comfort. The patient is also receiving emotional support from the staff.\n\n • The video then goes on to explain the difference between care and caring. Care is the provision of medical treatment and services. Caring is the provision of emotional support and compassion.\n\nThe video argues that both care and caring are important for providing high-quality healthcare. Care is essential for treating patients' physical needs, while caring is essential for meeting their emotional needs.\n\nThe video concludes by emphasizing the importance of compassion and empathy in healthcare. Compassion and empathy can help to make patients feel more comfortable and supported during their illness.\n",
                        ),
                      ),
                    ),
                    ModuleItem(
                      icon: Icons.play_circle_fill,
                      title: "Caring: Video",
                      color: Colors.red,
                      targetPage: VideoPage(
                        youtubeLink:
                            "https://www.youtube.com/watch?v=wkf-WxMZVP8",
                        modulePath: "Module0.caringVideo",
                        descriptionText:
                            "The video begins with a patient in palliative care who is in pain. The patient is receiving IV access, and the staff is working to manage their pain and provide them with comfort. The patient is also receiving emotional support from the staff.\n\nThe video then goes on to explain the difference between care and caring. Care is the provision of medical treatment and services. Caring is the provision of emotional support and compassion.\n\nThe video argues that both care and caring are important for providing high-quality healthcare. Care is essential for treating patients' physical needs, while caring is essential for meeting their emotional needs.\n\nThe video concludes by emphasizing the importance of compassion and empathy in healthcare. Compassion and empathy can help to make patients feel more comfortable and supported during their illness.\n",
                      ),
                    ),
                    ModuleItem(
                        icon: Icons.description,
                        title: "Empathy : Definition",
                        color: Colors.grey,
                        targetPage: ImagePage(
                          svgImagePath: "EmpathyDefinition.jpeg",
                          modulePath: "Module0.EmpathyDefinition",
                          descriptionText:
                              "Empathy is the ability to understand and share the feelings of another person. In healthcare, it involves connecting with patients emotionally and understanding their perspective.",
                        )),
                    ModuleItem(
                      icon: Icons.play_circle_fill,
                      title: "Empathy: Video",
                      color: Colors.red,
                      targetPage: VideoPage(
                        youtubeLink:
                            "https://www.youtube.com/watch?v=7zk_AJBO60Y",
                        modulePath: "Module0.EmpathyVideo",
                        descriptionText:
                            'The video "How The Human Connection Improves Healthcare" by Anthony Orsini is a powerful and insightful talk about the importance of human connection in healthcare. Orsini shares a personal story about a tragic event that occurred during his medical training, which led him to realize that medicine is not just about science and technology, but also about the human connection between doctors and patients.\n\nHe argues that the current healthcare system, with its emphasis on efficiency and technology, has led to a decline in the quality of patient care. Doctors and nurses are often overworked and stressed, which can lead to burnout and a lack of compassion. As a result, patients may feel rushed and undervalued, which can negatively impact their health outcomes.\n\nOrsini emphasizes the importance of building rapport and trust with patients. He suggests that doctors should take the time to get to know their patients on a personal level, and to listen actively to their concerns. By doing so, doctors can create a more positive and supportive environment for their patients, which can lead to better health outcomes.\n\nThe video concludes with a call to action for both doctors and patients. Orsini encourages doctors to prioritize human connection in their practice, and to take steps to reduce burnout and stress. He also encourages patients to be proactive in their healthcare, and to communicate openly and honestly with their doctors. By working together, doctors and patients can create a healthcare system that is more patient-centered and compassionate.\n',
                      ),
                    ),
                    ModuleItem(
                        icon: Icons.quiz,
                        title: "Empathy: Quiz",
                        color: Colors.brown,
                        targetPage: QuizDialog(quizKey: "quiz2")),
                    ModuleItem(
                        icon: Icons.description,
                        title: "Human Connection : Definition",
                        color: Colors.grey,
                        targetPage: ImagePage(
                          svgImagePath: "HumanConnection.jpeg",
                          modulePath: "Module0.HumanConnectionDefinition",
                          descriptionText:
                              "Human connection in healthcare refers to building meaningful relationships with patients based on trust, understanding, and emotional support, which enhances the healing process.",
                        )),
                    ModuleItem(
                      icon: Icons.play_circle_fill,
                      title: "Human Connection : Video",
                      color: Colors.red,
                      targetPage: VideoPage(
                        youtubeLink:
                            "https://www.youtube.com/watch?v=7zk_AJBO60Y",
                        modulePath: "Module0.HumanConnectionVideo",
                      ),
                    ),

                    ModuleItem(
                        icon: Icons.description,
                        title: "Professionalism : Definition",
                        color: Colors.grey,
                        targetPage: ImagePage(
                          svgImagePath: "Professionalism.jpeg",
                          modulePath: "Module0.ProfessionalismDefinition",
                          descriptionText:
                              "Professionalism involves maintaining high standards of behavior, ethical conduct, and responsibility in healthcare, including clear communication, confidentiality, and respect for patients.",
                        )),

                    ModuleItem(
                      icon: Icons.play_circle_fill,
                      title: "Professionalism : Video",
                      color: Colors.red,
                      targetPage: VideoPage(
                        youtubeLink:
                            "https://www.youtube.com/watch?v=DLo0a42sOHA",
                        modulePath: "Module0.ProfessionalismVideo",
                      ),
                    ),
                  ]),

              const SizedBox(height: 10),
              ModuleWidget(
                moduleName: "Module 1",
                items: [
                  ModuleItem(
                    icon: Icons.play_circle_fill,
                    title: "Video Lecture",
                    color: Colors.red,
                    targetPage: VideoPage(
                      youtubeLink:
                          'https://youtu.be/VJ_s51QGbg8?si=uSgRfQniW9ur4GxS',
                      modulePath: 'Module1.intro',
                      descriptionText:
                          'Objective: Understand the basic concept and importance of ethics in healthcare.\n\nDescription: Introducing the concept of ethics, its relevance in healthcare, and why it is important for healthcare professionals.',
                      backPage: const HistoricalContextPage1_2(),
                      nextPage: const HistoricalContextPage1_2(),
                    ),
                  ),
                  ModuleItem(
                      icon: Icons.description,
                      title: "Lecture Notes",
                      color: Colors.grey,
                      targetPage: QuizDialog(quizKey: "quiz1")),
                  ModuleItem(
                      icon: Icons.assignment,
                      title: "Assignment",
                      color: Colors.orange,
                      targetPage: const HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.quiz,
                      title: "Quiz",
                      color: Colors.brown,
                      targetPage: const HistoricalContextPage1_2()),
                ],
              ),
              const SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 2",
                items: [
                  ModuleItem(
                      icon: Icons.video_library,
                      title: "New Video Content",
                      color: Colors.blue,
                      targetPage: const HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.notes,
                      title: "Special Notes",
                      color: Colors.green,
                      targetPage: const HistoricalContextPage1_2()),
                ],
              ),
              const SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 3",
                items: [
                  ModuleItem(
                      icon: Icons.book,
                      title: "Reading Material",
                      color: Colors.purple,
                      targetPage: const HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.assignment_late,
                      title: "Pending Tasks",
                      color: Colors.red,
                      targetPage: const HistoricalContextPage1_2()),
                ],
              ),
              const SizedBox(height: 10), // Space between modules
              ModuleWidget(
                moduleName: "Module 4",
                items: [
                  ModuleItem(
                      icon: Icons.video_call,
                      title: "Live Session",
                      color: Colors.teal,
                      targetPage: const HistoricalContextPage1_2()),
                  ModuleItem(
                      icon: Icons.feedback,
                      title: "Feedback Form",
                      color: Colors.amber,
                      targetPage: const HistoricalContextPage1_2()),
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
              color: const Color(0XFFA1D55D),
              border: Border.all(color: Colors.black, width: 2),
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.moduleName,
              style: const TextStyle(
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0),
              ),
            ),
            child: Column(
              children:
                  widget.items.map((item) => buildListItem(item)).toList(),
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
            builder: (context) =>
                item.targetPage, // Directly navigate to the target page
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
