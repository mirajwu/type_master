import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assetTextures/homeButtons.dart';
import 'assetTextures/gradientText.dart';
import '/view/newGame.dart';

void main() => runApp(TypeMaster());

class TypeMaster extends StatelessWidget {
  const TypeMaster({super.key});

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
                    'TYPE MASTER',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = gradientText,
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
                // NEW GAME BUTTON
                const SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    height: 75,
                    child:
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewGame()));
                      },
                      style: homeButtonStyle,
                      child: Text('New Game'),
                    )
                ),
                // LEADERBOARD BUTTON
                const SizedBox(height: 32),
                SizedBox(
                    width: 300,
                    height: 75,
                    child:
                    ElevatedButton(
                      onPressed: () {
                        showDialog (
                          context: context,
                          builder: (context) => Dialog(
                            child: Container (
                              decoration: BoxDecoration(
                                color: Color(0xFF3F4689),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column (
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'Leaderboard',
                                    style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Row (
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom (
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text('Shuffle'),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom (
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text('Paragraphs'),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                      height: 0,
                                      thickness: 1,
                                      indent: 25,
                                      endIndent: 25,
                                      color: Colors.grey
                                  ),
                                  const SizedBox(height: 512),
                                ],
                              )
                            ),
                          ),
                        );
                      },
                      style: homeButtonStyle,
                      child: Text('Leaderboard'),
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
                      child: Text('Credits'),
                    )
                ),
                // EXIT BUTTON
                const SizedBox(height: 32),
                SizedBox(
                    width: 300,
                    height: 75,
                    child:
                    ElevatedButton(
                      onPressed: () => SystemNavigator.pop(),
                      style: homeButtonStyle,
                      child: Text('Exit'),
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

