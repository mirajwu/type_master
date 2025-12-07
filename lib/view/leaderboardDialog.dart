import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'styles/textStyles.dart';

class LeaderboardDialogBox  extends StatelessWidget {
  const LeaderboardDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container (
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3F4689),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column (
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 24),
                  SizedBox(
                      height: 512,
                      width: 288,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF333970),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                            child:
                            Column (
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('1. Dwayne',
                                          style: leaderboardTextStyle
                                      ),
                                      Text('144 WPM',
                                          style: leaderboardTextStyle
                                      ),
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('2. Matt',
                                          style: leaderboardTextStyle
                                      ),
                                      Text('70 WPM',
                                          style: leaderboardTextStyle
                                      ),
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('3. Taro',
                                          style: leaderboardTextStyle
                                      ),
                                      Text('90 WPM',
                                          style: leaderboardTextStyle
                                      ),
                                    ]
                                ),
                                const SizedBox(height: 8),
                              ],
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 20)
                ],
              )
          ),
          Positioned (
            top: 0,
            right: 0,
            height: 32,
            width: 32,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: const CircleBorder(),
                    backgroundColor: Color(0xFFAF3D3D),
                    foregroundColor: Colors.white,
                    side: BorderSide(width: 2, color: Color(0xFF933333))
                ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/exit.png'
              )
          ),
          )
        ],
      )
    );
  }
}