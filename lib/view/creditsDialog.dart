import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'styles/textStyles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles/buttonStyles.dart';

class CreditsDialogBox  extends StatelessWidget {
  const CreditsDialogBox({super.key});

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
                      'Credits',
                      style: GoogleFonts.roboto(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MADE WITH LOVE BY:',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 12),
                    const Divider(
                        height: 0,
                        thickness: 1,
                        indent: 25,
                        endIndent: 25,
                        color: Colors.grey
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                        height: 360,
                        width: 288,
                        child: Column (
                          children: [
                            SizedBox(
                                width: 250,
                                height: 100,
                                child:
                                ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse('https://github.com/mirajwu');
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  style: creditButtonStyle,
                                  child: Text('Dwayne Manuel'),
                                )
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                                width: 250,
                                height: 100,
                                child:
                                ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse('https://github.com/mattcanarejo001-svg');
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  style: creditButtonStyle,
                                  child: Text('Matt Canarejo'),
                                )
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                                width: 250,
                                height: 100,
                                child:
                                ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse('https://github.com/crstntaro');
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  style: creditButtonStyle,
                                  child: Text('Cristian Gannaban'),
                                )
                            )
                          ],
                        )
                    ),
                    const SizedBox(height: 8)
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