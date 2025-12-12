import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_styles.dart';
import '../controller/game_controller.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _textKey = GlobalKey();

  void _scrollToCursor(String text, int currentIndex) {
    if (!_scrollController.hasClients) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 28, fontFamily: 'Courier', height: 1.5),
      ),
      textDirection: TextDirection.ltr,
    );

    final screenWidth = MediaQuery.of(context).size.width - 40;
    textPainter.layout(maxWidth: screenWidth);

    final cursorOffset = textPainter.getOffsetForCaret(
      TextPosition(offset: currentIndex),
      Rect.zero,
    );

    final double targetScroll = cursorOffset.dy - 100;

    _scrollController.animateTo(
      targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);

    if (controller.timeLeft <= 0 && !controller.isPlaying && !controller.isCountdown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: kMainBackgroundGradient),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        Text(controller.currentMode, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text("0:${controller.timeLeft.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),

                    LinearProgressIndicator(
                      value: controller.timeLeft / 60,
                      backgroundColor: Colors.white24,
                      color: kPrimaryCyan,
                    ),

                    const SizedBox(height: 40),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if(controller.isPlaying) _focusNode.requestFocus();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white12)
                          ),
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: RichText(
                              key: _textKey,
                              text: TextSpan(
                                style: const TextStyle(fontSize: 28, fontFamily: 'Courier', height: 1.5, color: Colors.white38),
                                children: [
                                  TextSpan(
                                    text: controller.currentText.substring(0, controller.currentIndex),
                                    style: const TextStyle(color: kPrimaryCyan, fontWeight: FontWeight.bold),
                                  ),
                                  if (controller.currentIndex < controller.currentText.length)
                                    TextSpan(
                                      text: controller.currentText[controller.currentIndex],
                                      style: const TextStyle(color: Colors.white, backgroundColor: Color(0xFF6E61AB)),
                                    ),
                                  if (controller.currentIndex + 1 < controller.currentText.length)
                                    TextSpan(
                                      text: controller.currentText.substring(controller.currentIndex + 1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("Tap box to type", style: TextStyle(color: Colors.white30)),
                  ],
                ),
              ),
            ),

            if (!controller.isPlaying)
              Container(
                color: Colors.black87,
                child: Center(
                  child: controller.isCountdown
                      ? Text("${controller.countdownVal}", style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: kPrimaryCyan))
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryCyan, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                    onPressed: () {
                      controller.startCountdown();
                      Future.delayed(const Duration(seconds: 3), () => _focusNode.requestFocus());
                    },
                    child: const Text("START", style: TextStyle(fontSize: 30, color: Colors.white)),
                  ),
                ),
              ),

            Opacity(
              opacity: 0,
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    controller.typeCharacter(val.substring(val.length - 1));
                    _inputController.clear();
                    _scrollToCursor(controller.currentText, controller.currentIndex);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}