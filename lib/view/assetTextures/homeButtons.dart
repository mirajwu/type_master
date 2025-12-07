import 'package:flutter/material.dart';

final ButtonStyle homeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF6E61AB),
  foregroundColor: Color(0xFFFFFFFF),
  textStyle: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold
  ),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16))
  ),
);