// import 'package:flutter/material.dart';
// import '../Services/QuizQuestion .dart';
// import '../widgets/quiz_page.dart'; // Import the quiz page
// import '../../Login Signup/Screen/home_screen.dart'; // Import the home screen

// class ResultPage extends StatelessWidget {
//   final int score;
//   final int totalQuestions;
//   final List<QuizQuestion> quizQuestions;
//   final String quizTitle; // Add this field to show the quiz title

//   const ResultPage({super.key, 
//     required this.score,
//     required this.totalQuestions,
//     required this.quizQuestions,
//     required this.quizTitle, // Initialize the field
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF3058a6),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         title: Text(
//           quizTitle,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ), // Display the quiz title
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
          
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'You scored $score out of $totalQuestions!',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3058a6),
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => QuizPage(
//                               questions: quizQuestions,
//                               quizId:
//                                   quizTitle, // Pass the same quiz ID for restarting
//                             ),
//                           ),
//                           (route) => false, // Remove all previous routes
//                         );
//                       },
//                       child: const Text(
//                         'Restart Quiz',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3058a6),
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomeScreen()),
//                           (route) => false, // Remove all previous routes
//                         );
//                       },
//                       child: const Text(
//                         'Back to Home',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
