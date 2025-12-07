import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'assetTextures/homeButtons.dart';
import 'assetTextures/gradientText.dart';

class NewGame extends StatelessWidget {
  const NewGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home: Scaffold (
        body: Center (
          child: Column (
            children: [
              // TEXT
              const SizedBox(height: 148),
              Text(
                  'GAME MODE',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = gradientText,
                  )
              ),
              // NEW GAME BUTTON
              const SizedBox(height: 20),
              SizedBox(
                  width: 300,
                  height: 75,
                  child:
                  ElevatedButton(
                    onPressed: () {},
                    style: homeButtonStyle,
                    child: Text('Shuffle'),
                  )
              ),
              // PARAGRAPHS BUTTON
              const SizedBox(height: 32),
              SizedBox(
                  width: 300,
                  height: 75,
                  child:
                  ElevatedButton(
                    onPressed: () {},
                    style: homeButtonStyle,
                    child: Text('Paragraphs'),
                  )
              ),
              // EXIT BUTTON
              const SizedBox(height: 32),
              SizedBox(
                  width: 300,
                  height: 75,
                  child:
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: homeButtonStyle,
                    child: Text('Back'),
                  )
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1A1523)),
    );
  }
}

