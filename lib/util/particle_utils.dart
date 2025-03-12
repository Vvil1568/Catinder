import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

Future<void> emojiConfetti(BuildContext context, String emoji) async {
  Confetti.launch(
    context,
    options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
    particleBuilder: (index) => Emoji(
      emoji: emoji,
    ),
  );
}
