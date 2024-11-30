import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Login Signup/Screen/modulesMenu.dart';
import '../../../Login Signup/Widget/snackbar.dart';
import '../../widgets/card.dart'; // Adjust the import path as per your structure
import '../../../Login Signup/Screen/modulesMenu.dart'; // Import the ModulesPage class

class HealthcareEthicsPage extends StatefulWidget {
  const HealthcareEthicsPage({super.key});

  @override
  _HealthcareEthicsPageState createState() => _HealthcareEthicsPageState();
}

class _HealthcareEthicsPageState extends State<HealthcareEthicsPage> {
  final videoURL = "https://youtu.be/VJ_s51QGbg8";
  YoutubePlayerController? _controller;
  bool _isConnected = true;
  bool _isLoading = false;
  bool _isComplete = false;
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _checkCompletionStatus(); // Check completion status on init
  }

  void _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    } else {
      _initializeYoutubePlayer();
    }
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(videoURL);
    if (videoId == null) {
      // Handle the error, maybe show a message to the user
      return;
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: true,
      ),
    );
    setState(() {
      _isConnected = true;
    });
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
                final isComplete = module1['1_1Overview'] ?? false;
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
        'completedModules.Module1.1_1Overview': true,
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
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Healthcare Ethics',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3058a6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to ModulesPage when the back button is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ModulePage()),
            );
          },
        ),
      ),
      body: _isConnected && _controller != null
          ? Stack(
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: const Color(0xFF3058a6),
                  ),
                  builder: (context, player) {
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: [
                          // Add padding around the player
                          player,
                          const SizedBox(height: 10),
                          _buildPrincipleCard(
                            context,
                            'Definition of Ethics',
                            'Ethics refers to moral principles that govern a person\'s behavior or conducting an activity.',
                            Icons.book,
                          ),
                          const SizedBox(height: 16),
                          _buildPrincipleCard(
                            context,
                            'Ethics in Healthcare',
                            'In healthcare, ethics is crucial as it guides professionals to act with integrity, respect, and responsibility.',
                            Icons.local_hospital,
                          ),
                          const SizedBox(height: 16),
                          _buildPrincipleCard(
                            context,
                            'Importance of Ethical Behavior',
                            'Ethical behavior ensures trust, fosters a positive relationship between patients and healthcare providers, and upholds the dignity of all individuals involved in healthcare.',
                            Icons.thumb_up,
                          ),
                          const SizedBox(height: 20),
                          // Add "Mark as Complete" button
                          Align(
                            alignment: Alignment.centerLeft, // Align the button to the start of the page
                            child: IntrinsicWidth(
                              // Make the button only as wide as its content
                              child: ElevatedButton(
                                onPressed: _isComplete || _isLoading
                                    ? null
                                    : _markModuleAsComplete,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3058a6),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Mark as Complete',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 205, 203, 203)),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(
              child: Text(
                'No internet connection. Please check your network settings.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

Widget _buildPrincipleCard(
    BuildContext context, String title, String description, IconData icon) {
  return PrincipleCard(
    title: title,
    description: description,
    icon: icon,
    primaryColor: const Color(0xFF3058a6),
  );
}
