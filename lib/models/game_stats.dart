class GameStats {
  int gamesPlayed;
  int gamesWon;
  int totalGuesses;
  int bestScore;
  double averageGuesses;

  GameStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalGuesses = 0,
    this.bestScore = 0,
    this.averageGuesses = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'totalGuesses': totalGuesses,
      'bestScore': bestScore,
      'averageGuesses': averageGuesses,
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      totalGuesses: json['totalGuesses'] ?? 0,
      bestScore: json['bestScore'] ?? 0,
      averageGuesses: (json['averageGuesses'] ?? 0).toDouble(),
    );
  }

  void updateStats({required bool won, required int guesses, required int score}) {
    gamesPlayed++;
    if (won) {
      gamesWon++;
      totalGuesses += guesses;
      averageGuesses = totalGuesses / gamesWon;
      if (score > bestScore) {
        bestScore = score;
      }
    }
  }
}
