import 'trick.dart';

const starterTricks = <Trick>[
  Trick(
    id: 'amber-force',
    title: 'Amber force',
    effect: 'They name a card. It lands second from the left.',
    method: 'Hold the named card under the left thumb and place it third in a five-card deal.',
    beats: [
      'Ask for a card as if any name will do.',
      'Shuffle. Keep their card under the thumb.',
      'Deal five onto the felt.',
      'Turn the second from the left. Then stop.',
    ],
  ),
  Trick(
    id: 'pocket-glimpse',
    title: 'Pocket glimpse',
    effect: 'A peeked card is named before the deck is spread.',
    method:
        'The break sits above the peeked card. Read the index while squaring.',
    beats: [
      'Have a card peeked, not taken.',
      'Square the deck and catch the index.',
      'Name the card, then spread.',
    ],
  ),
  Trick(
    id: 'four-quiet',
    title: 'Four quiet',
    effect: 'Four face-down cards turn out to be one four of a kind.',
    method: 'The packet is already a four of a kind. The cut is false.',
    beats: [
      'Show four ordinary cards. Do not linger.',
      'Cut the packet once, falsely.',
      'Turn the set over together.',
    ],
  ),
];
