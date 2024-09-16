import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text,Color col) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: col,
      content: Text(text),
    ),
  );
}
