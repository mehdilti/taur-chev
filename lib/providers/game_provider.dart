import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/sound_service.dart';
import '../models/game_stats.dart';

class GameProvider with ChangeNotifier {
  final SoundService _soundService = SoundService();  late final SharedPreferences _prefs;
  GameStats _stats = GameStats();
  
  List<int> _secretNumber = [];
  List<List<int>> _guesses = [];
  List<Map<String, int>> _results = [];
  bool _isGameOver = false;
  bool _hasWon = false;
  int _highScore = 0;
  int _currentScore = 0;

  GameProvider() {
    _initPrefs();
    _generateNewNumber();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadStats();
  }

  void _loadStats() {
    final statsJson = _prefs.getString('gameStats');
    if (statsJson != null) {
      _stats = GameStats.fromJson(Map<String, dynamic>.from(
        const JsonDecoder().convert(statsJson),
      ));
      _highScore = _stats.bestScore;
    }
  }

  void _saveStats() {
    _prefs.setString('gameStats', const JsonEncoder().convert(_stats.toJson()));
  }

  List<int> get secretNumber => _secretNumber;
  List<List<int>> get guesses => _guesses;
  List<Map<String, int>> get results => _results;
  bool get isGameOver => _isGameOver;
  bool get hasWon => _hasWon;
  int get highScore => _highScore;
  int get currentScore => _currentScore;
  GameStats get stats => _stats;

  void _generateNewNumber() {
    final random = Random();
    final digits = List.generate(10, (index) => index);
    _secretNumber = [];
    
    for (int i = 0; i < 4; i++) {
      final index = random.nextInt(digits.length);
      _secretNumber.add(digits[index]);
      digits.removeAt(index);
    }
  }

  void _calculateScore() {
    if (_hasWon) {
      _currentScore = 100 - (_guesses.length - 1) * 10;
      if (_currentScore > _highScore) {
        _highScore = _currentScore;
      }
    } else {
      _currentScore = 0;
    }
  }

  Map<String, int> checkGuess(List<int> guess) {
    int bulls = 0;
    int cows = 0;

    for (int i = 0; i < 4; i++) {
      if (guess[i] == _secretNumber[i]) {
        bulls++;
      } else if (_secretNumber.contains(guess[i])) {
        cows++;
      }
    }

    _guesses.add(List.from(guess));
    _results.add({'bulls': bulls, 'cows': cows});

    if (bulls == 4) {
      _isGameOver = true;
      _hasWon = true;
      _calculateScore();
      _stats.updateStats(won: true, guesses: _guesses.length, score: _currentScore);
      _saveStats();
      _soundService.playWinSound();
    } else if (_guesses.length >= 10) {
      _isGameOver = true;
      _hasWon = false;
      _calculateScore();
      _stats.updateStats(won: false, guesses: _guesses.length, score: 0);
      _saveStats();
      _soundService.playLoseSound();
    } else {
      _soundService.playClickSound();
    }

    notifyListeners();
    return {'bulls': bulls, 'cows': cows};
  }

  void resetGame() {
    _secretNumber = [];
    _guesses = [];
    _results = [];
    _isGameOver = false;
    _hasWon = false;
    _generateNewNumber();
    notifyListeners();
  }

  @override
  void dispose() {
    _soundService.dispose();
    super.dispose();
  }
}