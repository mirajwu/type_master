import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_styles.dart'; // This imports the file we created in Step 2
import 'mode_selection_screen.dart';
import 'dialogs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: kMainBackgroundGradient),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 148),
              Text('TYPE MASTER',
                  style: TextStyle(
                    fontSize: 48, fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = kGradientTextShader,
                  )),
              const Divider(color: Colors.white, indent: 15, endIndent: 15),
              const SizedBox(height: 32),

              SizedBox(
                width: 300, height: 75,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen())),
                  style: kHomeButtonStyle,
                  child: const Text('New Game'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300, height: 75,
                child: ElevatedButton(
                  onPressed: () => showDialog(context: context, builder: (_) => const LeaderboardDialogBox()),
                  style: kHomeButtonStyle,
                  child: const Text('Leaderboard'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300, height: 75,
                child: ElevatedButton(
                  onPressed: () => showDialog(context: context, builder: (_) => const CreditsDialogBox()),
                  style: kHomeButtonStyle,
                  child: const Text('Credits'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300, height: 75,
                child: ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: kHomeButtonStyle,
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}