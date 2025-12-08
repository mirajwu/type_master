import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles/buttonStyles.dart';
import 'styles/textStyles.dart';
import '/view/newGame.dart';

void main() => runApp(NewGame());

class Shuffle extends StatefulWidget {
  const Shuffle({super.key});

  @override
  State<Shuffle> createState() => _ShuffleState();
}

class _ShuffleState extends State<Shuffle> {
  final TextEditingController _usernameController = TextEditingController();

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
                  // BACK BUTTON
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
                  const SizedBox(height: 161),
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
                      color: Colors.white
                  ),
                  // USERNAME INPUT
                  SizedBox(
                    width: 350,
                    height: 80,
                    child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF836FB7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          cursorColor: Colors.white,
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none
                          ),
                        )
                    ),
                  ),
                  // START BUTTON
                  const SizedBox(height: 16),
                  SizedBox(
                      width: 150,
                      height: 50,
                      child:
                      ElevatedButton(
                        onPressed: () {},
                        style: homeButtonStyle,
                        child: Text('Start'),
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

