import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'username_entry_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: kMainBackgroundGradient),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Back Button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 20),
            Text('GAME MODE',
                style: TextStyle(
                  fontSize: 48, fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = kGradientTextShader,
                )),
            const Divider(color: Colors.white, indent: 15, endIndent: 15),
            const SizedBox(height: 50),

            // SHUFFLE
            SizedBox(
              width: 300, height: 75,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const UsernameEntryScreen(mode: 'Shuffle')));
                },
                style: kHomeButtonStyle,
                child: const Text('Shuffle'),
              ),
            ),
            const SizedBox(height: 32),

            // PARAGRAPHS
            SizedBox(
              width: 300, height: 75,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const UsernameEntryScreen(mode: 'Paragraphs')));
                },
                style: kHomeButtonStyle,
                child: const Text('Paragraphs'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}