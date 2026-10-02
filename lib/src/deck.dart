import 'dart:math';

import 'playing_card.dart';

class Deck {
  const Deck(this.cards);

  final List<PlayingCard> cards;

  static Deck ordered() {
    return Deck([
      for (final suit in Suit.values)
        for (final rank in Rank.values) PlayingCard(rank, suit),
    ]);
  }

  Deck shuffled(Random random) {
    final next = List<PlayingCard>.of(cards);
    for (var i = next.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final held = next[i];
      next[i] = next[j];
      next[j] = held;
    }
    return Deck(List<PlayingCard>.unmodifiable(next));
  }

  Deck withCardAt(PlayingCard card, int index) {
    final next = [
      for (final item in cards)
        if (item != card) item,
    ];
    final slot = index < 0 ? 0 : (index > next.length ? next.length : index);
    next.insert(slot, card);
    return Deck(List<PlayingCard>.unmodifiable(next));
  }

  List<PlayingCard> deal(int count) {
    final take = count < cards.length ? count : cards.length;
    return List<PlayingCard>.unmodifiable(cards.take(take));
  }
}
