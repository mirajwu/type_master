import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles/buttonStyles.dart';
import 'styles/textStyles.dart';
import '/view/newGame.dart';

void main() => runApp(NewGame());

class NewGame extends StatelessWidget {
  const NewGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home: Scaffold (
        body: Center (
            child: Container (
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF322756),
                      Color(0xFF1E1733),
                      Color(0xFF161126),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment. bottomCenter
                ),
              ),
              child: Column (
                children: [
                  // TEXT
                  const SizedBox(height: 148),
                  Text(
                      'ENTER USERNAME',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = gradientText,
                      )
                  ),
                  // LINE
                  const Divider(
                      height: 0,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                      color: Colors.grey
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
            )
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1A1523)),
    );
  }
}

