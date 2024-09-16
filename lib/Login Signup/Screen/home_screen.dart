import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4771f5),
        title: const Center(
          child: Text("Home Page",
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        ),
      ),
      
    );
  }
}
