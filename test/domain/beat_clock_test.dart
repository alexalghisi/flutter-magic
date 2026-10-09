import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/rehearsal_page.dart';

void main() {
  test('the clock stays at zero until the rehearsal starts', () {
    final clock = BeatClock();
    expect(clock.label, '00:00');
    clock.advance(const Duration(seconds: 4));
    expect(clock.label, '00:00');
    clock.start();
    clock.advance(const Duration(seconds: 3));
    expect(clock.label, '00:03');
    clock.advance(const Duration(seconds: 60));
    expect(clock.label, '01:03');
  });
}
