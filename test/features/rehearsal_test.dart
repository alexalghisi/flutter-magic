import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('beats advance and the clock counts seconds', (tester) async {
    await pumpLantern(tester);
    await tester.tap(find.text('Amber force'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rehearse-trick')));
    await tester.pumpAndSettle();

    expect(find.text('Ready'), findsOneWidget);
    expect(find.text('Ask for a card as if any name will do.'), findsOneWidget);
    final back = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Back'),
    );
    expect(back.onPressed, isNull);

    await tester.tap(find.text('Begin'));
    await tester.pump();
    expect(find.text('00:00'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('00:03'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(
      find.text('Shuffle. Keep their card under the thumb.'),
      findsOneWidget,
    );
    expect(find.text('Beat 2 of 4'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pump();
    expect(find.text('Beat 1 of 4'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('Done'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Effect'), findsOneWidget);
  });

  testWidgets('rehearsal without beats asks for one', (tester) async {
    await pumpLantern(tester, tricks: const [], nextId: () => 'trick-1');
    await tester.tap(find.widgetWithText(FloatingActionButton, 'New trick'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rehearse-trick')));
    await tester.pumpAndSettle();
    expect(find.text('Add a beat before you rehearse.'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('trick-title')), findsOneWidget);
  });
}
