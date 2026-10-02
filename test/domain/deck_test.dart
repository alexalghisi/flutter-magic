import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/deck.dart';
import 'package:lantern/src/playing_card.dart';
import 'package:lantern/src/table_controller.dart';

void main() {
  test('a fresh deck has 52 unique cards', () {
    final deck = Deck.ordered();
    expect(deck.cards, hasLength(52));
    expect(deck.cards.toSet(), hasLength(52));
    expect(deck.cards.first, const PlayingCard(Rank.ace, Suit.spades));
    expect(deck.cards.last, const PlayingCard(Rank.king, Suit.clubs));
  });

  test('a seeded shuffle is stable and keeps every card', () {
    final random = Random(12);
    final once = Deck.ordered().shuffled(random);
    final twice = Deck.ordered().shuffled(Random(12));
    expect(once.cards, twice.cards);
    expect(once.cards.toSet(), Deck.ordered().cards.toSet());
    expect(once.deal(5), once.cards.take(5));
  });

  test('withCardAt parks one card and does not grow the deck', () {
    final force = const PlayingCard(Rank.king, Suit.hearts);
    final parked = Deck.ordered().shuffled(Random(2)).withCardAt(force, 1);
    expect(parked.cards, hasLength(52));
    expect(parked.cards[1], force);
    expect(parked.cards.toSet(), hasLength(52));
  });

  test('control holds the named card second from the left', () {
    final controller = TableController(random: Random(3));
    expect(controller.hand, hasLength(5));
    for (var i = 0; i < 12; i++) {
      controller.shuffle();
      expect(controller.hand[TableController.forceSeat], controller.force);
      expect(controller.hand.toSet(), hasLength(5));
    }

    controller.setForce(const PlayingCard(Rank.queen, Suit.diamonds));
    expect(controller.hand[1].spoken, 'Queen of Diamonds');

    controller.setControlled(false);
    final seen = <PlayingCard>{};
    for (var i = 0; i < 20; i++) {
      controller.shuffle();
      seen.add(controller.hand[1]);
    }
    expect(seen.length, greaterThan(1));
  });
}
