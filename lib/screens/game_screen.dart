import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/victory_animation.dart';
import '../widgets/stats_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitGuess() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    // Vérifier si tous les champs sont remplis
    if (_controllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les chiffres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final guess = _controllers.map((c) => int.parse(c.text)).toList();
    gameProvider.checkGuess(guess);
    
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showRules() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Règles du jeu'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Le but du jeu est de deviner un nombre secret de 4 chiffres.\n\n'
                'Après chaque tentative, vous recevrez deux informations :\n\n'
                '🎯 Taureaux : le nombre de chiffres corrects et bien placés\n'
                '🐎 Chevaux : le nombre de chiffres corrects mais mal placés\n\n'
                'Exemple :\n'
                'Nombre secret : 1234\n'
                'Votre essai : 1432\n'
                'Résultat : 2 taureaux (1,2) et 2 chevaux (3,4)\n\n'
                'Vous avez 10 tentatives pour trouver le nombre secret.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris !'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,      appBar: AppBar(
        title: const Text(
          'Taureaux et Chevaux',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StatsDialog(
                  stats: Provider.of<GameProvider>(context, listen: false).stats,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showRules,
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (gameProvider.isGameOver)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: gameProvider.hasWon ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [                        gameProvider.hasWon
                          ? VictoryAnimation(
                              child: Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 48,
                              ),
                            )
                          : Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                        const SizedBox(height: 8),
                        Text(
                          gameProvider.hasWon
                              ? 'Félicitations ! Vous avez gagné !\nScore: ${gameProvider.currentScore} points${gameProvider.currentScore == gameProvider.highScore ? "\nNouveau record !" : ""}'
                              : 'Game Over ! Le nombre était ${gameProvider.secretNumber.join()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (gameProvider.highScore > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Meilleur score : ${gameProvider.highScore}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Entrez votre proposition',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Vérifier si c'est un chiffre
                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      _controllers[index].text = '';
                                      return;
                                    }
                                    
                                    // Vérifier si le chiffre est déjà utilisé
                                    final digit = int.parse(value);
                                    final otherDigits = _controllers
                                        .where((c) => c != _controllers[index])
                                        .map((c) => c.text)
                                        .where((t) => t.isNotEmpty)
                                        .map((t) => int.parse(t))
                                        .toList();
                                        
                                    if (otherDigits.contains(digit)) {
                                      _controllers[index].text = '';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Chaque chiffre ne peut être utilisé qu\'une seule fois'),
                                          backgroundColor: Colors.orange,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    // Passer au champ suivant
                                    if (index < 3) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: gameProvider.isGameOver
                              ? gameProvider.resetGame
                              : _submitGuess,
                          icon: Icon(
                            gameProvider.isGameOver ? Icons.refresh : Icons.check,
                          ),
                          label: Text(
                            gameProvider.isGameOver ? 'Nouvelle partie' : 'Deviner',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: gameProvider.guesses.length,
                      itemBuilder: (context, index) {
                        final guess = gameProvider.guesses[index];
                        final result = gameProvider.results[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              'Tentative: ${guess.join()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.adjust,
                                    color: theme.colorScheme.primary,
                                    size: 16),
                                Text(' Taureaux: ${result['bulls']}'),
                                const SizedBox(width: 16),
                                Icon(Icons.pets,
                                    color: theme.colorScheme.secondary,
                                    size: 16),
                                Text(' Chevaux: ${result['cows']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}