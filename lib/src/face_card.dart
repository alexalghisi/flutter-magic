import 'package:flutter/material.dart';

import 'playing_card.dart';
import 'theme.dart';

class FaceCard extends StatelessWidget {
  const FaceCard({
    required this.card,
    required this.width,
    required this.height,
    required this.held,
    super.key,
  });

  final PlayingCard card;
  final double width;
  final double height;
  final bool held;

  @override
  Widget build(BuildContext context) {
    final inkColor = card.suit.red
        ? const Color(0xFFB4332A)
        : const Color(0xFF1A140F);
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      decoration: BoxDecoration(
        color: cardFace,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: held ? amber : const Color(0xFFD9D0C3),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.rank.short,
            style: TextStyle(
              color: inkColor,
              fontWeight: FontWeight.w700,
              fontSize: width < 56 ? 12 : 16,
            ),
          ),
          Text(
            card.suit.mark,
            style: TextStyle(color: inkColor, fontSize: width < 56 ? 14 : 20),
          ),
        ],
      ),
    );
  }
}
