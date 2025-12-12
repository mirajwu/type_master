import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_words/english_words.dart';
import '../model/score_entry.dart';

class GameController extends ChangeNotifier {
  static const String _keyScores = 'scores';
  static const String _keyLastUser = 'last_user';

  String currentText = "";
  int currentIndex = 0;
  int errors = 0;
  int timeLeft = 60;

  bool isPlaying = false;
  bool isCountdown = false;
  int countdownVal = 3;

  Timer? _gameTimer;
  Timer? _countdownTimer;

  String currentMode = "Shuffle";
  String username = "Player 1";
  List<String> _allPhrases = [];

  int get wpm {
    double timeElapsedMinutes = (60 - timeLeft) / 60;
    if (timeElapsedMinutes <= 0 || currentIndex == 0) return 0;
    return ((currentIndex / 5) / timeElapsedMinutes).round();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString(_keyLastUser) ?? "Player 1";
    notifyListeners();
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

  Future<void> initGame(String mode) async {
    currentMode = mode;
    errors = 0;
    currentIndex = 0;
    timeLeft = 60;
    isPlaying = false;
    isCountdown = false;

    if (mode == 'Paragraphs') {
      try {
        String fileText = await rootBundle.loadString('assets/phrases.txt');
        _allPhrases = fileText.split('\n').where((p) => p.trim().isNotEmpty).toList();
        _allPhrases.shuffle();
        currentText = _allPhrases.take(50).join(" ");
      } catch (e) {
        currentText = "The quick brown fox jumps over the lazy dog. " * 10;
      }
    } else {
      List<String> words = generateWordPairs().take(100).map((e) => "${e.first} ${e.second}").toList();
      currentText = words.join(" ");
    }

    // Normalize spaces
    currentText = currentText.replaceAll(RegExp(r'\s+'), ' ').trim();
    notifyListeners();
  }

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
    if (!isPlaying || currentIndex >= currentText.length) return;

    if (char == currentText[currentIndex]) {
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
}