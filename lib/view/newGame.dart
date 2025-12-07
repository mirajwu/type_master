import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:type_master_game/view/enterShuffleUsername.dart';
import 'styles/buttonStyles.dart';
import 'styles/textStyles.dart';

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
                  SizedBox(
                    height: 128,
                    width: 400,
                    child: Row (
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                shape: const CircleBorder(),
                                backgroundColor: Colors.transparent,
                                side: BorderSide.none
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 32,
                            )
                        ),
                      ],
                    ),
                  ),
                  // TEXT
                  const SizedBox(height: 20),
                  Text(
                      'GAME MODE',
                      style: TextStyle(
                        fontSize: 48,
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
                      color: Colors.white
                  ),
                  // NEW GAME BUTTON
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 300,
                      height: 75,
                      child:
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Shuffle()));
                          },
                        style: homeButtonStyle,
                        child: Text('Shuffle'),
                      )
                  ),
                  // CREDITS BUTTON
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
                ],
              ),
            )
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1A1523)),
    );
  }
}

