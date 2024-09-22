import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../Login Signup/Widget/snackbar.dart';
import '../../widgets/card.dart';

const Color primaryColor = Color(0xFF3058a6);

class EnhancedAudioPlayerPage extends StatefulWidget {
  @override
  _EnhancedAudioPlayerPageState createState() =>
      _EnhancedAudioPlayerPageState();
}

class _EnhancedAudioPlayerPageState extends State<EnhancedAudioPlayerPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration();
  Duration _position = Duration();
  bool isPlaying = false;
  bool isMuted = false;
  bool isLoading = false;
  bool isStopped = false;
  bool _isConnected = true;
  bool _isLoading = false;
  bool _isComplete = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _position = Duration();
          isPlaying = false;
        });
      }
    });

    _checkCompletionStatus();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

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
                final isComplete = module1['1_4Podcast'] ?? false;
                setState(() {
                  _isComplete = isComplete;
                });
              }
            }
          }
        }
      } catch (e) {
        showSnackBar(context, 'Error: $e', Colors.red);
      }
    }
  }

  Future<void> _markModuleAsComplete() async {
    if (!_isConnected) {
      showSnackBar(
          context,
          'No internet connection. Please check your network settings.',
          Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('users').doc(userId).update({
        'completedModules.Module1.1_4Podcast': true,
        'score': FieldValue.increment(50),
      });

      setState(() {
        _isComplete = true;
        _isLoading = false;
      });
      showSnackBar(context, '🥳 Module marked as complete and 50 points added!',
          Colors.green);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Error: $e', Colors.red);
    }
  }

  void playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() {
        isLoading = true;
      });
      await _audioPlayer.play(AssetSource('audio/1.4Module1Podcast.wav'));
      setState(() {
        isLoading = false;
        isStopped = false;
      });
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void stop() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration();
      isPlaying = false;
      isStopped = true;
    });
  }

  void muteUnmute() {
    if (isMuted) {
      _audioPlayer.setVolume(1.0);
    } else {
      _audioPlayer.setVolume(0.0);
    }
    setState(() {
      isMuted = !isMuted;
    });
  }

  void rewind() {
    final newPosition = _position.inSeconds - 10;
    _audioPlayer.seek(Duration(seconds: newPosition > 0 ? newPosition : 0));
  }

  void forward() {
    final newPosition = _position.inSeconds + 10;
    if (newPosition < _duration.inSeconds) {
      _audioPlayer.seek(Duration(seconds: newPosition));
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Enhanced Podcast Player',
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 1,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPrincipleCard(
                    context,
                    'Understanding Ethical Vulnerability',
                    'Ethical vulnerability refers to situations where healthcare practitioners face challenges in making ethical decisions due to various pressures.\n\n'
                        'It can arise from conflicting duties, resource limitations, and personal biases.',
                    Icons.info,
                  ),
                  _buildPrincipleCard(
                    context,
                    'Types of Ethical Vulnerability',
                    'Professional: Conflicts between professional duties and ethical principles, such as issues of confidentiality or professional boundaries.\n\n'
                        'Institutional: Ethical issues stemming from healthcare policies, organizational culture, or systemic inequalities.\n\n'
                        'Personal: Emotional and moral dilemmas experienced by healthcare professionals, such as burnout, moral distress, or personal biases.',
                    Icons.list,
                  ),
                  _buildPrincipleCard(
                    context,
                    'Addressing Ethical Vulnerability',
                    'Developing strategies to support ethical decision-making, such as ethical committees, guidelines, and regular training.\n\n'
                        'Encouraging a culture of openness where healthcare professionals can discuss and seek guidance on ethical issues.',
                    Icons.support,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isLoading
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.replay_10,
                                        color: primaryColor),
                                    iconSize: screenWidth * 0.09,
                                    onPressed: rewind,
                                  ),
                                  GestureDetector(
                                    onTap: playPause,
                                    child: CircleAvatar(
                                      radius: screenWidth * 0.07,
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: screenWidth * 0.09,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.forward_10,
                                        color: primaryColor),
                                    iconSize: screenWidth * 0.09,
                                    onPressed: forward,
                                  ),
                                ],
                              ),
                        SizedBox(height: screenHeight * 0.02),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColor.withOpacity(0.3),
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withOpacity(0.2),
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: screenWidth * 0.03),
                          ),
                          child: Slider(
                            value: _position.inSeconds.toDouble(),
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                _audioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(_position),
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            Text(
                              formatTime(_duration),
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment
                        .centerLeft, // Align the button to the start of the page
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
                                    color: Color.fromARGB(255, 205, 203, 203)),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
