enum Rank {
  ace('A', 'Ace'),
  two('2', 'Two'),
  three('3', 'Three'),
  four('4', 'Four'),
  five('5', 'Five'),
  six('6', 'Six'),
  seven('7', 'Seven'),
  eight('8', 'Eight'),
  nine('9', 'Nine'),
  ten('10', 'Ten'),
  jack('J', 'Jack'),
  queen('Q', 'Queen'),
  king('K', 'King');

  const Rank(this.short, this.label);

  final String short;
  final String label;
}

enum Suit {
  spades('♠', 'Spades', false),
  hearts('♥', 'Hearts', true),
  diamonds('♦', 'Diamonds', true),
  clubs('♣', 'Clubs', false);

  const Suit(this.mark, this.label, this.red);

  final String mark;
  final String label;
  final bool red;
}

class PlayingCard {
  const PlayingCard(this.rank, this.suit);

  final Rank rank;
  final Suit suit;

  String get spoken => '${rank.label} of ${suit.label}';

  @override
  bool operator ==(Object other) =>
      other is PlayingCard && other.rank == rank && other.suit == suit;

  @override
  int get hashCode => Object.hash(rank, suit);
}
