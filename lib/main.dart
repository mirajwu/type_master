import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_words/english_words.dart';
import 'package:google_fonts/google_fonts.dart'; // Added as used in frontend
import 'package:url_launcher/url_launcher.dart'; // Added as used in frontend

// --- MAIN ENTRY POINT ---
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()..loadUser()),
      ],
      child: const TypeMasterApp(),
    ),
  );
}

class TypeMasterApp extends StatelessWidget {
  const TypeMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Type Master',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00B4D8), // Cyan/Blue
        scaffoldBackgroundColor: const Color(0xFF1A1523), // Dark Navy from frontend
        fontFamily: 'Courier',
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ============================================================================
//                                   MODEL
// ============================================================================

class ScoreEntry {
  final String username;
  final int wpm;
  final int errors;
  final String mode;
  final DateTime date;

  ScoreEntry({required this.username, required this.wpm, required this.errors, required this.mode, required this.date});

  Map<String, dynamic> toJson() => {
    'username': username, 'wpm': wpm, 'errors': errors, 'mode': mode, 'date': date.toIso8601String(),
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    username: json['username'], wpm: json['wpm'], errors: json['errors'], mode: json['mode'], date: DateTime.parse(json['date']),
  );
}

// ============================================================================
//                                 CONTROLLER
// ============================================================================

class GameController extends ChangeNotifier {
  // Data Persistence Keys
  static const String _keyScores = 'scores';
  static const String _keyLastUser = 'last_user';

  // Game State
  String currentText = "";
  int currentIndex = 0;
  int errors = 0;
  int timeLeft = 60;

  // Status Flags
  bool isPlaying = false;
  bool isCountdown = false;
  int countdownVal = 3;

  Timer? _gameTimer;
  Timer? _countdownTimer;

  String currentMode = "Classic";
  String username = "Player 1";

  // Storage for loaded phrases
  List<String> _allPhrases = [];

  int get wpm {
    double timeElapsedMinutes = (60 - timeLeft) / 60;
    if (timeElapsedMinutes <= 0 || currentIndex == 0) return 0;
    return ((currentIndex / 5) / timeElapsedMinutes).round();
  }

  // --- Persistence Methods ---
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString(_keyLastUser);
    if (saved != null) {
      username = saved;
      notifyListeners();
    }
  }

  Future<void> saveUser(String name) async {
    final prefs = await SharedPreferences.getInstance();
    username = name;
    await prefs.setString(_keyLastUser, name);
    notifyListeners();
  }

  Future<List<ScoreEntry>> getLeaderboard(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList(_keyScores);
    if (list == null) return [];

    List<ScoreEntry> scores = list.map((e) => ScoreEntry.fromJson(jsonDecode(e))).toList();
    var filtered = scores.where((e) => e.mode == mode).toList();
    filtered.sort((a, b) => b.wpm.compareTo(a.wpm));
    return filtered;
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList(_keyScores) ?? [];

    ScoreEntry newScore = ScoreEntry(
      username: username, wpm: wpm, errors: errors, mode: currentMode, date: DateTime.now(),
    );

    list.add(jsonEncode(newScore.toJson()));
    await prefs.setStringList(_keyScores, list);
  }

  // --- Game Initialization ---
  Future<void> initGame(String mode) async {
    currentMode = mode;
    errors = 0;
    currentIndex = 0;
    timeLeft = 60;
    isPlaying = false;
    isCountdown = false;

    if (mode == 'Paragraphs') { // Renamed from 'Classic' to match frontend button
      try {
        String fileText = await rootBundle.loadString('assets/phrases.txt');
        _allPhrases = fileText.split('\n').where((p) => p.trim().isNotEmpty).toList();

        if (_allPhrases.isEmpty) throw Exception("Empty file");

        _allPhrases.shuffle();

        List<String> gameTextList = [];
        for(int i=0; i<50; i++) {
          gameTextList.add(_allPhrases[i % _allPhrases.length].trim());
        }
        currentText = gameTextList.join(" ");

      } catch (e) {
        _allPhrases = ["The quick brown fox jumps over the lazy dog."];
        currentText = List.generate(50, (index) => _allPhrases[0]).join(" ");
      }
    } else {
      // SHUFFLE MODE
      List<String> words = generateWordPairs()
          .take(400)
          .map((e) => "${e.first} ${e.second}") // Space separated
          .toList();

      currentText = words.join(" ");
    }

    currentText = currentText.replaceAll(RegExp(r'\s+'), ' ');

    notifyListeners();
  }

  // Countdown Logic
  void startCountdown() {
    isCountdown = true;
    countdownVal = 3;
    notifyListeners();

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownVal > 1) {
        countdownVal--;
        notifyListeners();
      } else {
        timer.cancel();
        isCountdown = false;
        _beginTypingSession();
      }
    });
  }

  // Start Timer
  void _beginTypingSession() {
    isPlaying = true;
    notifyListeners();

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        finishGame();
      }
    });
  }

  void typeCharacter(String char) {
    if(!isPlaying) return;
    if (currentIndex >= currentText.length) return;

    if(char == currentText[currentIndex]) {
      currentIndex++;
    } else {
      errors++;
    }
    notifyListeners();
  }

  void finishGame() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    isPlaying = false;
    saveScore();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}

// ============================================================================
//                                   VIEWS
// ============================================================================

// --------------------------- 1. WELCOME SCREEN ---------------------------
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Styles from frontend
    final ButtonStyle homeButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6E61AB),
      foregroundColor: Color(0xFFFFFFFF),
      textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    );

    final Shader gradientText = const LinearGradient(
      colors: [Colors.blueAccent, Colors.redAccent, Colors.amber],
    ).createShader(const Rect.fromLTWH(0, 0, 440, 80));

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF322756), Color(0xFF1E1733), Color(0xFF161126)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 100), // Adjusted height

              // Username Display/Input Trigger (Added functionality to frontend UI)
              Consumer<GameController>(
                builder: (context, controller, _) {
                  return InkWell(
                    onTap: () => _showUsernameDialog(context, controller),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Hi, ${controller.username} (Tap to change)",
                          style: const TextStyle(color: Colors.grey, fontSize: 14)
                      ),
                    ),
                  );
                },
              ),

              Text(
                'TYPE MASTER',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = gradientText,
                ),
              ),
              const Divider(height: 0, thickness: 1, indent: 15, endIndent: 15, color: Colors.grey),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ModeSelectionScreen()));
                  },
                  style: homeButtonStyle,
                  child: const Text('New Game'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => const LeaderboardDialogBox());
                  },
                  style: homeButtonStyle,
                  child: const Text('Leaderboard'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => const CreditsDialogBox());
                  },
                  style: homeButtonStyle,
                  child: const Text('Credits'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: homeButtonStyle,
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUsernameDialog(BuildContext context, GameController controller) {
    final txtCtrl = TextEditingController(text: controller.username);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Username"),
        content: TextField(controller: txtCtrl),
        actions: [
          TextButton(
            onPressed: () {
              if (txtCtrl.text.isNotEmpty) controller.saveUser(txtCtrl.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}

// ----------------------- 2. MODE SELECTION SCREEN ------------------------
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle homeButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6E61AB),
      foregroundColor: Color(0xFFFFFFFF),
      textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    );

    final Shader gradientText = const LinearGradient(
      colors: [Colors.blueAccent, Colors.redAccent, Colors.amber],
    ).createShader(const Rect.fromLTWH(0, 0, 440, 80));

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF322756), Color(0xFF1E1733), Color(0xFF161126)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 148),
              Text(
                'GAME MODE',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = gradientText,
                ),
              ),
              const Divider(height: 0, thickness: 1, indent: 15, endIndent: 15, color: Colors.grey),

              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    // Initialize Shuffle
                    Provider.of<GameController>(context, listen: false).initGame('Shuffle');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                  style: homeButtonStyle,
                  child: const Text('Shuffle'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    // Initialize Paragraphs
                    Provider.of<GameController>(context, listen: false).initGame('Paragraphs');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                  style: homeButtonStyle,
                  child: const Text('Paragraphs'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: homeButtonStyle,
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- 3. GAME SCREEN ---------------------------
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCursor(int currentIndex) {
    if (!_scrollController.hasClients) return;
    const int charsPerLine = 25;
    const double lineHeight = 42.0;
    int currentLine = (currentIndex / charsPerLine).floor();
    double targetOffset = (currentLine * lineHeight);

    if (targetOffset > _scrollController.position.maxScrollExtent) {
      targetOffset = _scrollController.position.maxScrollExtent;
    }

    if (targetOffset > _scrollController.offset + 100) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);

    if (controller.timeLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      Text(controller.currentMode, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Go Tap That Kibord bro", style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),
                  Text("0:${controller.timeLeft.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),

                  LinearProgressIndicator(
                    value: controller.timeLeft / 60,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFF00B4D8),
                  ),

                  const Spacer(),

                  // Typing Area
                  GestureDetector(
                    onTap: () {
                      if(controller.isPlaying) _focusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white10,
                      width: double.infinity,
                      height: 300,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 28, fontFamily: 'Courier', height: 1.5),
                            children: [
                              TextSpan(
                                text: controller.currentText.length > controller.currentIndex
                                    ? controller.currentText.substring(0, controller.currentIndex)
                                    : controller.currentText,
                                style: const TextStyle(color: Color(0xFF00B4D8), fontWeight: FontWeight.bold),
                              ),
                              if (controller.currentIndex < controller.currentText.length)
                                TextSpan(
                                  text: controller.currentText[controller.currentIndex],
                                  style: const TextStyle(color: Colors.white, backgroundColor: Colors.grey),
                                ),
                              if (controller.currentIndex + 1 < controller.currentText.length)
                                TextSpan(
                                  text: controller.currentText.substring(controller.currentIndex + 1),
                                  style: const TextStyle(color: Colors.white24),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text("Type using your keyboard!", style: TextStyle(color: Colors.white30)),
                ],
              ),
            ),
          ),

          // START / COUNTDOWN OVERLAY
          if (!controller.isPlaying)
            Container(
              color: Colors.black87,
              child: Center(
                child: controller.isCountdown
                    ? Text(
                  "${controller.countdownVal}",
                  style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Color(0xFF00B4D8)),
                )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B4D8),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)
                  ),
                  onPressed: () {
                    controller.startCountdown();
                    Future.delayed(const Duration(seconds: 3), () {
                      _focusNode.requestFocus();
                    });
                  },
                  child: const Text("START GAME", style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
              ),
            ),

          // INVISIBLE INPUT
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                autofocus: false,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (String value) {
                  if (value.isNotEmpty) {
                    String lastChar = value.substring(value.length - 1);
                    controller.typeCharacter(lastChar);
                    _inputController.clear();
                    _scrollToCursor(controller.currentIndex);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --------------------------- 4. RESULT SCREEN ---------------------------
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("RESULT", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            _statBox("Username", controller.username),
            _statBox("WPM", "${controller.wpm}"),
            _statBox("Errors", "${controller.errors}"),
            _statBox("Mode", controller.currentMode),

            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B4D8)),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text("BACK TO HOME", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("$label: $value", style: const TextStyle(fontSize: 22)),
    );
  }
}

// ----------------------- 5. LEADERBOARD DIALOG -----------------------
class LeaderboardDialogBox extends StatefulWidget {
  const LeaderboardDialogBox({super.key});
  @override
  State<LeaderboardDialogBox> createState() => _LeaderboardDialogBoxState();
}

class _LeaderboardDialogBoxState extends State<LeaderboardDialogBox> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3F4689),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Leaderboard',
                  style: GoogleFonts.roboto(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TabBar(
                  controller: _tabController,
                  tabs: const [Tab(text: "Shuffle"), Tab(text: "Paragraphs")],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList("Shuffle"),
                      _buildList("Paragraphs"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList(String mode) {
    return FutureBuilder<List<ScoreEntry>>(
      future: Provider.of<GameController>(context, listen: false).getLeaderboard(mode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var list = snapshot.data!;
        if (list.isEmpty) return const Center(child: Text("No scores yet.", style: TextStyle(color: Colors.white)));
        return ListView.separated(
          itemCount: list.length,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("#${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              title: Text(list[index].username, style: const TextStyle(color: Colors.white)),
              trailing: Text("${list[index].wpm} WPM", style: const TextStyle(color: Color(0xFF00B4D8), fontWeight: FontWeight.bold)),
            );
          },
        );
      },
    );
  }
}

// ----------------------- 6. CREDITS DIALOG -----------------------
class CreditsDialogBox extends StatelessWidget {
  const CreditsDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle creditButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF303568),
      foregroundColor: const Color(0xFFFFFFFF),
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    );

    return Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F4689),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Credits',
                      style: GoogleFonts.roboto(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('MADE WITH LOVE BY:', style: GoogleFonts.roboto(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Divider(height: 0, thickness: 1, indent: 25, endIndent: 25, color: Colors.grey),
                    const SizedBox(height: 24),
                    SizedBox(
                        height: 360,
                        width: 288,
                        child: Column(
                          children: [
                            _buildCreditButton('Dwayne Manuel', 'https://github.com/mirajwu', creditButtonStyle),
                            const SizedBox(height: 16),
                            _buildCreditButton('Matt Canarejo', 'https://github.com/mattcanarejo001-svg', creditButtonStyle),
                            const SizedBox(height: 16),
                            _buildCreditButton('Cristian Gannaban', 'https://github.com/crstntaro', creditButtonStyle),
                          ],
                        )
                    ),
                    const SizedBox(height: 20)
                  ],
                )
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        )
    );
  }

  Widget _buildCreditButton(String name, String url, ButtonStyle style) {
    return SizedBox(
        width: 250,
        height: 100,
        child: ElevatedButton(
          onPressed: () async {
            final Uri uri = Uri.parse(url);
            if (!await launchUrl(uri)) {
              throw Exception('Could not launch $uri');
            }
          },
          style: style,
          child: Text(name, textAlign: TextAlign.center),
        )
    );
  }
}