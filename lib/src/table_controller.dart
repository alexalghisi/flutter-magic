import 'dart:math';

import 'package:flutter/foundation.dart';

import 'deck.dart';
import 'playing_card.dart';

class TableController extends ChangeNotifier {
  TableController({
    Random? random,
    this.force = const PlayingCard(Rank.ace, Suit.spades),
  }) : _random = random ?? Random() {
    _deal();
  }

  final Random _random;
  PlayingCard force;
  var controlled = true;
  List<PlayingCard> hand = const [];
  var dealCount = 0;

  static const forceSeat = 1;

  void setForce(PlayingCard card) {
    force = card;
    _deal();
    notifyListeners();
  }

  void setControlled(bool value) {
    controlled = value;
    _deal();
    notifyListeners();
  }

  void shuffle() {
    _deal();
    notifyListeners();
  }

  void _deal() {
    final shuffled = Deck.ordered().shuffled(_random);
    final deck = controlled ? shuffled.withCardAt(force, forceSeat) : shuffled;
    hand = deck.deal(5);
    dealCount += 1;
  }
}
