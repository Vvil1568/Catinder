import 'package:flutter/material.dart';

import '../util/particle_utils.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String emoji;
  final bool spawnParticles;

  const CustomButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.emoji,
      this.spawnParticles = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        onPressed.call();
        if (spawnParticles) {
          emojiConfetti(context, emoji);
        }
      },
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(theme.colorScheme.inversePrimary),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
        child: Icon(
          icon,
          size: 40,
          color: Colors.red,
        ),
      ),
    );
  }
}
