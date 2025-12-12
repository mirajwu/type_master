import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_styles.dart';
import '../controller/game_controller.dart';
import 'game_screen.dart';

class UsernameEntryScreen extends StatefulWidget {
  final String mode;
  const UsernameEntryScreen({super.key, required this.mode});

  @override
  State<UsernameEntryScreen> createState() => _UsernameEntryScreenState();
}

class _UsernameEntryScreenState extends State<UsernameEntryScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with last saved username
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lastUser = Provider.of<GameController>(context, listen: false).username;
      _usernameController.text = lastUser;
    });
  }

  void _startGame() {
    if (_usernameController.text.isNotEmpty) {
      final ctrl = Provider.of<GameController>(context, listen: false);
      ctrl.saveUser(_usernameController.text);
      ctrl.initGame(widget.mode);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GameScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: kMainBackgroundGradient),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 120),
            Text('ENTER USERNAME',
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = kGradientTextShader,
                )),
            const Divider(color: Colors.white, indent: 15, endIndent: 15),

            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF836FB7), borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white, fontSize: 24),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 150, height: 50,
              child: ElevatedButton(
                onPressed: _startGame,
                style: kHomeButtonStyle,
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}