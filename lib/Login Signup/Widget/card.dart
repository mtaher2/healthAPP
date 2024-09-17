import 'package:flutter/material.dart';

class PrincipleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;

  const PrincipleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xfff6f2f1), // Background color of the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: primaryColor,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black //primaryColor.withOpacity(0.7), // Slightly lighter for better readability
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
