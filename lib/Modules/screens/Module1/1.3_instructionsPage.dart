import 'package:flutter/material.dart';
import '../../Services/QuizQuestion .dart';
import '../../widgets/quiz_page.dart'; // Ensure you have this page created

class InstructionsPage extends StatelessWidget {
  List<QuizQuestion> exampleQuizQuestions = [
  QuizQuestion(
    scenario: 'A patient diagnosed with a severe medical condition is offered two treatment options by their doctor. Treatment A is more effective but comes with significant side effects, while Treatment B is less effective but has minimal side effects. The patient, after understanding the risks and benefits, decides to opt for Treatment B, prioritizing quality of life over the effectiveness of the treatment.',
    question: 'Which ethical principle is being applied in this scenario?',
    options: ['Beneficence', 'Non-Maleficence', 'Autonomy', 'Justice'],
    correctAnswerIndex: 2,
    rationale: 'The patient is exercising their right to make an informed decision about their treatment options, reflecting the principle of autonomy.',
  ),
  QuizQuestion(
    scenario: 'A healthcare team decides to provide a patient with a comprehensive rehabilitation program to improve their quality of life after a major surgery, even though the standard care would have been sufficient.',
    question: 'Which ethical principle is the healthcare team prioritizing?',
    options: ['Justice', 'Autonomy', 'Non-Maleficence', 'Beneficence'],
    correctAnswerIndex: 3,
    rationale: 'The healthcare team is acting to promote the well-being and welfare of the patient, going beyond the minimum required care.',
  ),
  QuizQuestion(
    scenario: 'A doctor is considering prescribing a new medication that has shown promise in early trials but has not been fully approved due to potential severe side effects. The doctor decides against prescribing it, opting for a safer, though less effective, alternative.',
    question: 'Which ethical principle influenced the doctor\'s decision?',
    options: ['Justice', 'Autonomy', 'Non-Maleficence', 'Beneficence'],
    correctAnswerIndex: 2,
    rationale: 'The doctor chose to avoid potential harm to the patient by not prescribing the unapproved medication, adhering to the principle of "do no harm."',
  ),
  QuizQuestion(
    scenario: 'In a rural hospital, there is a shortage of certain life-saving medications. The hospital decides to allocate these medications based on a triage system that prioritizes patients based on the severity of their condition and the likelihood of recovery.',
    question: 'What ethical principle is guiding the hospital\'s decision-making process?',
    options: ['Justice', 'Autonomy', 'Non-Maleficence', 'Beneficence'],
    correctAnswerIndex: 0,
    rationale: 'The hospital is ensuring a fair and equitable distribution of limited resources, focusing on the needs of the patients and their likelihood of benefit.',
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
          'Quiz Instructions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF3058a6), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Ethical Principles Quiz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3058a6), // Primary color
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6d90c6), // Secondary color
              ),
            ),
            const SizedBox(height: 10),
            // Bulleted list using Rows
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Read the Scenario: Each question presents a healthcare situation.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Choose the Best Principle: Select the ethical principle that best fits the situation.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Submit Your Answer: Click "Submit" to see if you’re right and get an explanation.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Move to the Next Question: Click "Next Question" to continue.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Finish the Quiz: Complete all questions to see your score.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '💡Tips:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6d90c6), // Secondary color
              ),
            ),
            const SizedBox(height: 10),
            // Bulleted list using Rows
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        'Think carefully about each scenario.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
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
                        'Review the feedback to learn more.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3058a6), // Primary color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage(questions: exampleQuizQuestions, quizId: 'Module1_QuizResult_1.3',)),
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
