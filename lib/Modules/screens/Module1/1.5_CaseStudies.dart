import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Modules/screens/Module1/1.5_ScenarioPage.dart';
import '../../Services/QuizQuestion .dart';
import '../../widgets/quiz_page.dart'; // Ensure you have this page created

class InstructionsPage1_5 extends StatelessWidget {
  List<QuizQuestion> exampleQuizQuestions123 = [
    //1
    QuizQuestion(
      scenario: 'A patient with a highly contagious and dangerous infectious disease refuses to inform their recent contacts and also does not want their diagnosis to be disclosed to public health authorities, citing their right to privacy. However, there is a significant risk that others could be infected if proper public health measures are not taken.',
      question: 'What should the healthcare provider do in this situation?',
      options: ['Respect the patient’s confidentiality and keep the diagnosis private.',
        'Inform the public health authorities to prevent a potential outbreak, even if it means breaching patient confidentiality.',
        'Try to persuade the patient to inform their contacts and allow the healthcare provider to notify public health authorities.',
        'Take no action and hope the patient changes their mind.'],
      correctAnswerIndex: 1,
      rationale: 'While patient confidentiality is crucial, the duty to protect public health and safety may override the confidentiality principle in this scenario to prevent harm to others.',
    ),
    //2
    QuizQuestion(
      scenario: 'An elderly patient with mild dementia expresses a desire to live independently in their home, despite concerns from their family and healthcare providers about their ability to care for themselves. The family insists on placing the patient in a supervised care facility, arguing that it is in the patient\'s best interest.',
      question: 'How should the healthcare team proceed?',
      options: ['Support the patient’s desire to live independently, respecting their autonomy.',
        'Respect the family\'s wishes and recommend placing the patient in a care facility for their safety.',
        'Assess the patient’s cognitive and physical abilities thoroughly and provide support for independent living if feasible.',
        'Refuse to get involved and leave the decision entirely to the family.'],
      correctAnswerIndex: 2,
      rationale: 'This solution balances respecting the patient\'s autonomy with the principle of beneficence by ensuring the patient’s safety while considering their wishes.',
    ),
    //3
    QuizQuestion(
      scenario: 'A new, expensive medication is available that can significantly improve the quality of life for patients with a rare disease. However, the hospital has limited resources and can only afford to provide the medication to a small number of patients. The selection criteria are not entirely clear, and some patients may not have equal access due to socioeconomic factors.',
      question: 'What approach should the hospital take?',
      options: ['Provide the medication to the first patients who request it, regardless of other factors.',
        'Allocate the medication based on the severity of the disease, ensuring it goes to those most in need.',
        'Conduct a lottery to randomly select patients who will receive the medication.',
        'Prioritize patients based on their ability to pay for the medication themselves.'],
      correctAnswerIndex: 1,
      rationale: 'This approach attempts to balance the principles of justice (fair distribution of resources) and non-maleficence (preventing harm by providing treatment to those most in need).',
    ),
    //4
    QuizQuestion(
      scenario: 'A young adult patient is brought to the emergency room unconscious and in critical condition after a car accident. The patient\'s parents arrive at the hospital and insist on refusing a life-saving blood transfusion based on their religious beliefs, stating that they are speaking on behalf of the patient.',
      question: 'What should the medical team do?',
      options: ['Follow the parents’ wishes and withhold the blood transfusion.',
        'Proceed with the transfusion, prioritizing the patient\'s life.',
        'Wait for the patient to regain consciousness and obtain their informed consent.',
        'Seek a court order to resolve the situation.'],
      correctAnswerIndex: 1,
      rationale: 'In an emergency, life-saving measures take precedence, and the healthcare team has an obligation to act in the patient\'s best interest (beneficence and non-maleficence). Informed consent is not feasible when the patient is unconscious, and delaying treatment could result in harm.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Case Studies and Scenarios ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF3058a6), // Primary color
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to 1.5 Case Studies and Scenarios ',
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 600 ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3058a6), // Primary color
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'In this section, you will:',
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 600 ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6d90c6), // Secondary color
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInstructionList(),
                  const SizedBox(height: 20),
                  Text(
                    '💡Tips:',
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 600 ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6d90c6), // Secondary color
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTipsList(),
                  const SizedBox(height: 20),
                  _buildButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInstructionRow('Engage with Interactive Case Studies: You’ll explore real-life scenarios where ethical principles may conflict, such as balancing patient confidentiality with public safety. Analyze these situations carefully, consider various perspectives, and choose the most ethical solution.'),
        const SizedBox(height: 5),
        _buildInstructionRow('Reflect Through Exercises: Reflect on your own values, biases, and ethical beliefs. Think deeply about how these personal perspectives influence your decisions and approach to the scenarios.'),
        const SizedBox(height: 5),
        _buildInstructionRow('Submit Your Answer: Click "Submit" to see if you’re right and get an explanation.'),
        const SizedBox(height: 5),
        _buildInstructionRow('Move to the Next Question: Click "Next Question" to continue.'),
        const SizedBox(height: 5),
        _buildInstructionRow('Finish the Quiz: Complete all questions to see your score.'),
      ],
    );
  }

  Widget _buildInstructionRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTipRow('Think carefully about each scenario.'),
        const SizedBox(height: 5),
        _buildTipRow('Review the feedback to learn more.'),
      ],
    );
  }

  Widget _buildTipRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3058a6), // Primary color
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage(questions: exampleQuizQuestions123, quizId: '1_5_Case Studies',)),
              );
            },
            child: const Text(
              'Start Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3058a6), // Primary color
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScenarioPage()),
              );
            },
            child: const Text(
              'Activity: Sensitive Topic',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
