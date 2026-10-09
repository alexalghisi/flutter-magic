import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lantern/src/app.dart';
import 'package:lantern/src/memory_trick_repository.dart';
import 'package:lantern/src/trick_library.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a new trick can be saved, rehearsed, and the felt still deals', (
    tester,
  ) async {
    final library = TrickLibrary(repository: MemoryTrickRepository());
    await tester.pumpWidget(
      LanternApp(
        library: library,
        nextId: () => 'trick-e2e',
        random: Random(4),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FloatingActionButton, 'New trick'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('trick-title')),
      'Cold reading',
    );
    await tester.tap(find.byKey(const Key('add-beat')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('beat-0')),
      'Ask for a first name.',
    );
    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();

    expect(find.text('Cold reading'), findsOneWidget);
    expect(library.tricks.single.beats, ['Ask for a first name.']);

    await tester.tap(find.text('Cold reading'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rehearse-trick')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Begin'));
    await tester.pump();
    expect(find.text('Ask for a first name.'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Table'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('seat-1')), findsOneWidget);
    expect(find.text('Ace of Spades is second from the left.'), findsOneWidget);
  });
}
