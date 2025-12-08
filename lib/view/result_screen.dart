import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_styles.dart';
import '../controller/game_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: kMainBackgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("RESULT", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, foreground: Paint()..shader = kGradientTextShader)),
              const SizedBox(height: 40),
              _statBox("Username", controller.username),
              _statBox("WPM", "${controller.wpm}"),
              _statBox("Errors", "${controller.errors}"),
              _statBox("Mode", controller.currentMode),
              const SizedBox(height: 50),
              ElevatedButton(
                style: kHomeButtonStyle,
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("Home"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("$label: $value", style: const TextStyle(fontSize: 24, color: Colors.white)),
    );
  }
}