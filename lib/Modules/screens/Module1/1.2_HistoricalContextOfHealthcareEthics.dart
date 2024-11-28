import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Login Signup/Widget/snackbar.dart';
import '../../widgets/card.dart';

class HistoricalContextPage1_2 extends StatefulWidget {
  const HistoricalContextPage1_2({super.key});

  @override
  _HistoricalContextPage1_2State createState() =>
      _HistoricalContextPage1_2State();
}

class _HistoricalContextPage1_2State extends State<HistoricalContextPage1_2> {
  // Define colors
  final Color primaryColor = const Color(0xFF3058a6);
  final Color secondaryColor = const Color(0xFF6d90c6);
  final Color accentColor = const Color(0xFFa4c6e5);
  final bool _isConnected = true;
  bool _isLoading = false;
  bool _isComplete = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkCompletionStatus(); // Check completion status on init
  }

  // Function to check if the module is already marked as complete
  Future<void> _checkCompletionStatus() async {
    if (user != null) {
      final userId = user!.uid;
      final firestore = FirebaseFirestore.instance;

      try {
        final doc = await firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            final completedModules = data['completedModules'] as Map?;
            if (completedModules != null) {
              final module1 = completedModules['Module1'] as Map?;
              if (module1 != null) {
                final isComplete = module1['1_2HistoricalContext'] ?? false;
                print("Module completion status: $isComplete"); // Debugging log
                setState(() {
                  _isComplete = isComplete;
                });
              } else {
                print("Module1 data is null."); // Debugging log
              }
            } else {
              print("CompletedModules data is null."); // Debugging log
            }
          } else {
            print("Document data is null."); // Debugging log
          }
        } else {
          print("Document does not exist."); // Debugging log
        }
      } catch (e) {
        showSnackBar(context, 'Error: $e', Colors.red);
      }
    }
  }

  // Function to mark module as complete and add points
  Future<void> _markModuleAsComplete() async {
    if (!_isConnected) {
      showSnackBar(
        context,
        'No internet connection. Please check your network settings.',
        Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      // Update user's module completion status and add points
      await firestore.collection('users').doc(userId).update({
        'completedModules.Module1.1_2HistoricalContext': true,
        'score': FieldValue.increment(50),
      });

      // Update the completion status
      setState(() {
        _isComplete = true;
        _isLoading = false;
      });
      showSnackBar(
        context,
        '🥳 Module marked as complete and 50 points added!',
        Colors.green,
      );
    } catch (e) {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Error: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Historical Context of Healthcare Ethics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPrincipleCard(
              context,
              'Hippocratic Oath',
              'An ancient code of medical ethics originating from ancient Greece.\n\n'
                  'Core principles include confidentiality, non-maleficence (do no harm), and benefiting the patient.\n\n'
                  'It\'s a foundational document for medical ethics, emphasizing the responsibilities of healthcare professionals.',
              Icons.local_hospital,
            ),
            const SizedBox(height: 16),
            _buildPrincipleCard(
              context,
              'Helsinki Declaration',
              'A set of ethical principles regarding human experimentation developed by the World Medical Association.\n\n'
                  'Focuses on informed consent, patient safety, and ethical considerations in medical research.',
              Icons.description,
            ),
            const SizedBox(height: 16),
            _buildPrincipleCard(
              context,
              'Geneva Declaration and Other Ethical Codes',
              'The Geneva Declaration is a modern restatement of the Hippocratic Oath, emphasizing medical ethics in a contemporary context.\n\n'
                  'Other codes include the Nuremberg Code and the Belmont Report, which provide guidelines for ethical research practices.',
              Icons.book,
            ),
            const SizedBox(height: 10),
            _buildImageWithOverlay(context),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment
                  .centerLeft, // Align the button to the start of the page
              child: IntrinsicWidth(
                // Make the button only as wide as its content
                child: ElevatedButton(
                  onPressed:
                      _isComplete || _isLoading ? null : _markModuleAsComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3058a6),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Mark as Complete',
                          style: TextStyle(
                              color: Color.fromARGB(255, 205, 203, 203)),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipleCard(
      BuildContext context, String title, String description, IconData icon) {
    return PrincipleCard(
      title: title,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
    );
  }

  Widget _buildImageWithOverlay(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImagePage(),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/images/Infographic_1.2_Historical.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.6),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Tap to view infographics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  const FullScreenImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Enables panning around the image
          minScale: 0.5, // Minimum zoom scale
          maxScale: 4.0, // Maximum zoom scale
          child: Image.asset(
            'assets/images/Infographic_1.2_Historical.png',
            fit: BoxFit
                .cover, // Ensures the image covers the screen in fullscreen mode
          ),
        ),
      ),
    );
  }
}
