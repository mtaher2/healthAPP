import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';

import '../Screen/modulesMenu.dart';
import 'buildTopButton.dart';
import 'buttonComplete.dart';
import 'navigationButton.dart';

class VideoPage extends StatefulWidget {
  final String youtubeLink;
  final String modulePath;
  final String? descriptionText;
  final Widget? nextPage;
  final Widget? backPage;

  VideoPage({
    required this.youtubeLink,
    required this.modulePath,
    this.descriptionText,
    this.nextPage,
    this.backPage,
  });

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  late ConfettiController _confettiController;
  bool _isComplete = false; // Completion status
  bool _isLoading = false; // For marking process
  final ValueNotifier<bool> _isFullscreen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeLink)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _checkCompletionStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkCompletionStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User is not authenticated');
      return;
    }

    final firestore = FirebaseFirestore.instance;

    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final completedModules = data['Modules'] as Map?;
          if (completedModules != null) {
            final module =
                completedModules[widget.modulePath.split('.')[0]] as Map?;
            if (module != null) {
              final isComplete =
                  module[widget.modulePath.split('.')[1]] ?? false;
              setState(() {
                _isComplete = isComplete;
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error checking completion status: $e');
    }
  }

  Future<void> _markModuleAsComplete() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User is not authenticated');
      return;
    }

    final firestore = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
    });

    try {
      await firestore.collection('users').doc(userId).update({
        'Modules.${widget.modulePath.split('.')[0]}.${widget.modulePath.split('.')[1]}':
            true,
        'score': FieldValue.increment(50),
      });

      setState(() {
        _isComplete = true;
        _isLoading = false;
      });

      _showCongratulationsDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error marking module as complete: $e');
    }
  }

  void _showCongratulationsDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.orange
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🎉 Congratulations!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You have completed this module and earned 50 points!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            0xffA1D55D), // Background color    // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Circular radius
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
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
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return ValueListenableBuilder<bool>(
    valueListenable: _isFullscreen,
    builder: (context, isFullscreen, child) {
      return Scaffold(
        appBar: isFullscreen
            ? null // Hide AppBar in fullscreen mode
            : PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              builder: (context) => ModulePage(), // Replace with your module page
                            ),
                          );
                        },
                        text: 'Back to Module',
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ),
              ),
        body: YoutubePlayerBuilder(
          onEnterFullScreen: () {
            _isFullscreen.value = true; // Enter fullscreen
          },
          onExitFullScreen: () {
            _isFullscreen.value = false; // Exit fullscreen
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onEnded: (_) {
              _isComplete ? null : _markModuleAsComplete();
            },
          ),
          builder: (context, player) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Adjust padding here
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: isFullscreen ? screenHeight : screenHeight * 0.4, // Adjust video height
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: player,
                      ),
                    ),
                  ),
                  if (!isFullscreen && widget.descriptionText != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.descriptionText!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  if (!isFullscreen)
                    const SizedBox(height: 16),
                  if (!isFullscreen)
                    ButtonComplete(
                      onPressed: _isComplete
                          ? null
                          : () {
                              _markModuleAsComplete();
                            },
                    ),
                  if (!isFullscreen)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.backPage != null)
                            NavigationButton(
                              isNext: false,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.backPage!,
                                  ),
                                );
                              },
                            ),
                          if (widget.nextPage != null)
                            NavigationButton(
                              isNext: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.nextPage!,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

}