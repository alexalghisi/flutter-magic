import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/trick.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('shelf lists starter tricks', (tester) async {
    await pumpLantern(tester);
    expect(find.text('Amber force'), findsOneWidget);
    expect(find.text('Pocket glimpse'), findsOneWidget);
    expect(find.text('Four quiet'), findsOneWidget);
    expect(find.text('4 beats'), findsOneWidget);
  });

  testWidgets('empty shelf tells you to write the first effect', (
    tester,
  ) async {
    await pumpLantern(tester, tricks: const []);
    expect(find.text('Nothing on the shelf yet.'), findsOneWidget);
  });

  testWidgets('save is refused until the trick has a title', (tester) async {
    await pumpLantern(tester, tricks: const [], nextId: () => 'trick-9');
    await tester.tap(find.widgetWithText(FloatingActionButton, 'New trick'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();
    expect(find.text('Give the trick a title.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('trick-title')),
      'Cold reading',
    );
    await tester.enterText(
      find.byKey(const Key('trick-effect')),
      'They feel seen.',
    );
    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();

    expect(find.text('Cold reading'), findsOneWidget);
    expect(find.text('They feel seen.'), findsOneWidget);
  });

  testWidgets('edit replaces the title and delete clears the shelf', (
    tester,
  ) async {
    final library = await pumpLantern(
      tester,
      tricks: const [
        Trick(
          id: 'amber-force',
          title: 'Amber force',
          effect: 'They name a card. It lands second from the left.',
          method: 'Hold the named card under the left thumb.',
          beats: ['Ask for a card as if any name will do.'],
        ),
      ],
    );

    await tester.tap(find.text('Amber force'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('trick-method')), findsNothing);
    expect(find.text('Method stays covered.'), findsOneWidget);

    await tester.tap(find.text('Uncover method'));
    await tester.pumpAndSettle();
    final method = tester.widget<TextField>(
      find.byKey(const Key('trick-method')),
    );
    expect(method.controller!.text, contains('thumb'));

    await tester.enterText(
      find.byKey(const Key('trick-title')),
      'Amber force II',
    );
    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();
    expect(find.text('Amber force II'), findsOneWidget);
    expect(library.tricks.single.title, 'Amber force II');

    await tester.tap(find.text('Amber force II'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove-trick')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing on the shelf yet.'), findsOneWidget);
    expect(library.tricks, isEmpty);
  });

  testWidgets('a beat can be added and a blank beat is dropped on save', (
    tester,
  ) async {
    final library = await pumpLantern(
      tester,
      tricks: const [],
      nextId: () => 'trick-4',
    );
    await tester.tap(find.widgetWithText(FloatingActionButton, 'New trick'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('trick-title')), 'Quiet pass');
    await tester.tap(find.byKey(const Key('add-beat')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('beat-0')), '   ');
    await tester.tap(find.byKey(const Key('add-beat')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('beat-1')), 'Pass the deck.');
    await tester.tap(find.byKey(const Key('save-trick')));
    await tester.pumpAndSettle();

    expect(library.tricks.single.beats, ['Pass the deck.']);
    expect(find.text('1 beat'), findsOneWidget);
  });
}
