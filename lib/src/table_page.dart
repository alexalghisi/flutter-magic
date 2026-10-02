import 'package:flutter/material.dart';

import 'face_card.dart';
import 'playing_card.dart';
import 'table_controller.dart';
import 'theme.dart';

class TablePage extends StatelessWidget {
  const TablePage({required this.controller, super.key});

  final TableController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final line = controller.controlled
            ? '${controller.force.spoken} is second from the left.'
            : 'Honest shuffle. Nothing is held.';
        return Scaffold(
          backgroundColor: felt,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                const Text(
                  'FELT',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 3.2,
                    color: amber,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Five cards',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: paper,
                  ),
                ),
                const SizedBox(height: 8),
                Text(line, style: const TextStyle(color: paper, height: 1.35)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _RankMenu(
                        rank: controller.force.rank,
                        onChanged: (rank) {
                          controller.setForce(
                            PlayingCard(rank, controller.force.suit),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SuitMenu(
                        suit: controller.force.suit,
                        onChanged: (suit) {
                          controller.setForce(
                            PlayingCard(controller.force.rank, suit),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Control the force',
                        style: TextStyle(color: paper),
                      ),
                    ),
                    Switch(
                      key: const Key('control-switch'),
                      value: controller.controlled,
                      onChanged: controller.setControlled,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: _Hand(
                    key: ValueKey(controller.dealCount),
                    hand: controller.hand,
                    heldSeat: controller.controlled
                        ? TableController.forceSeat
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: controller.shuffle,
                  child: const Text('Shuffle'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Hand extends StatelessWidget {
  const _Hand({required this.hand, required this.heldSeat, super.key});

  final List<PlayingCard> hand;
  final int? heldSeat;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final width =
            (constraints.maxWidth - gap * (hand.length - 1)) / hand.length;
        final height = width * 1.42;
        return Row(
          children: [
            for (var i = 0; i < hand.length; i++) ...[
              if (i > 0) const SizedBox(width: gap),
              FaceCard(
                key: Key('seat-$i'),
                card: hand[i],
                width: width,
                height: height,
                held: heldSeat == i,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RankMenu extends StatelessWidget {
  const _RankMenu({required this.rank, required this.onChanged});

  final Rank rank;
  final ValueChanged<Rank> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Rank>(
      key: const Key('force-rank'),
      isExpanded: true,
      value: rank,
      dropdownColor: const Color(0xFF241C16),
      items: [
        for (final item in Rank.values)
          DropdownMenuItem(value: item, child: Text(item.label)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _SuitMenu extends StatelessWidget {
  const _SuitMenu({required this.suit, required this.onChanged});

  final Suit suit;
  final ValueChanged<Suit> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Suit>(
      key: const Key('force-suit'),
      isExpanded: true,
      value: suit,
      dropdownColor: const Color(0xFF241C16),
      items: [
        for (final item in Suit.values)
          DropdownMenuItem(
            value: item,
            child: Text('${item.mark}  ${item.label}'),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
