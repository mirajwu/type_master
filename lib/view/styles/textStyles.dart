import 'package:flutter/material.dart';

final Shader gradientText = const LinearGradient(
  colors: [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.amber],
).createShader(const Rect.fromLTWH(0, 0, 440, 80));

final leaderboardTextStyle = TextStyle (
    fontSize: 16,
    color: Colors.white
);
