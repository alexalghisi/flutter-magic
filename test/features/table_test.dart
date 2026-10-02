import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('the felt deals five cards and holds the force', (tester) async {
    await pumpLantern(tester, random: Random(9));
    await tester.tap(find.text('Table'));
    await tester.pumpAndSettle();

    expect(find.text('Ace of Spades is second from the left.'), findsOneWidget);
    for (var i = 0; i < 5; i++) {
      expect(find.byKey(Key('seat-$i')), findsOneWidget);
    }
    expect(
      find.descendant(
        of: find.byKey(const Key('seat-1')),
        matching: find.text('A'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Shuffle'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('seat-1')),
        matching: find.text('A'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('control-switch')));
    await tester.pumpAndSettle();
    expect(find.text('Honest shuffle. Nothing is held.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('force-rank')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('control-switch')));
    await tester.pumpAndSettle();
    expect(find.text('Two of Spades is second from the left.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('seat-1')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
  });
}
