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
  final GlobalKey _textKey = GlobalKey(); // Key for the RichText container

  // THIS FIXES THE BUG
  void _scrollToCursor(String text, int currentIndex) {
    if (!_scrollController.hasClients) return;

    // 1. Create a TextPainter with the exact same styles as the UI
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 28, fontFamily: 'Courier', height: 1.5),
      ),
      textDirection: TextDirection.ltr,
    );

    // 2. Layout the text constrained by the screen width
    // We assume a padding of 40 (20 left + 20 right)
    final screenWidth = MediaQuery.of(context).size.width - 40;
    textPainter.layout(maxWidth: screenWidth);

    // 3. Get the exact (x, y) offset of the cursor
    final cursorOffset = textPainter.getOffsetForCaret(
      TextPosition(offset: currentIndex),
      Rect.zero,
    );

    // 4. Scroll so the cursor is roughly in the middle of the box
    final double targetScroll = cursorOffset.dy - 100; // Keep 100px padding above cursor

    _scrollController.animateTo(
      targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);

    // Navigate to Results when time is up
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        Text(controller.currentMode, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Timer
                    Text("0:${controller.timeLeft.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),

                    LinearProgressIndicator(
                      value: controller.timeLeft / 60,
                      backgroundColor: Colors.white24,
                      color: kPrimaryCyan,
                    ),

                    const SizedBox(height: 40),

                    // TYPING AREA
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
                                  // Correctly typed part
                                  TextSpan(
                                    text: controller.currentText.substring(0, controller.currentIndex),
                                    style: const TextStyle(color: kPrimaryCyan, fontWeight: FontWeight.bold),
                                  ),
                                  // Current character cursor
                                  if (controller.currentIndex < controller.currentText.length)
                                    TextSpan(
                                      text: controller.currentText[controller.currentIndex],
                                      style: const TextStyle(color: Colors.white, backgroundColor: Color(0xFF6E61AB)),
                                    ),
                                  // Remaining text
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

            // START OVERLAY
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

            // HIDDEN INPUT
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