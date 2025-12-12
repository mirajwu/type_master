import 'package:flutter/material.dart';

// --- COLORS ---
const Color kBgColorTop = Color(0xFF322756);
const Color kBgColorMid = Color(0xFF1E1733);
const Color kBgColorBot = Color(0xFF161126);
const Color kPrimaryCyan = Color(0xFF00B4D8);
const Color kDialogBg = Color(0xFF3F4689);

// --- GRADIENTS ---
const LinearGradient kMainBackgroundGradient = LinearGradient(
  colors: [kBgColorTop, kBgColorMid, kBgColorBot],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

final Shader kGradientTextShader = const LinearGradient(
  colors: [Colors.blueAccent, Colors.redAccent, Colors.amber],
).createShader(const Rect.fromLTWH(0, 0, 440, 80));

// --- BUTTON STYLES ---
final ButtonStyle kHomeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF6E61AB),
  foregroundColor: const Color(0xFFFFFFFF),
  textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16))),
);

final ButtonStyle kCreditButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF303568),
  foregroundColor: const Color(0xFFFFFFFF),
  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16))),
);

// --- TEXT STYLES ---
final TextStyle kLeaderboardTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white
);