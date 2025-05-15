import 'package:flutter/material.dart';
import '../models/game_stats.dart';

class StatsDialog extends StatelessWidget {
  final GameStats stats;

  const StatsDialog({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final winRate = stats.gamesPlayed > 0
        ? (stats.gamesWon / stats.gamesPlayed * 100).toStringAsFixed(1)
        : '0.0';

    return AlertDialog(
      title: const Text('Statistiques'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatItem(
            icon: Icons.games,
            label: 'Parties jouées',
            value: '${stats.gamesPlayed}',
          ),
          _StatItem(
            icon: Icons.emoji_events,
            label: 'Parties gagnées',
            value: '${stats.gamesWon}',
          ),
          _StatItem(
            icon: Icons.percent,
            label: 'Taux de victoire',
            value: '$winRate%',
          ),
          _StatItem(
            icon: Icons.speed,
            label: 'Moyenne de coups',
            value: stats.averageGuesses.toStringAsFixed(1),
          ),
          _StatItem(
            icon: Icons.stars,
            label: 'Meilleur score',
            value: '${stats.bestScore}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
