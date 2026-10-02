import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/app.dart';
import 'package:lantern/src/memory_trick_repository.dart';
import 'package:lantern/src/starter.dart';
import 'package:lantern/src/trick.dart';
import 'package:lantern/src/trick_library.dart';

Future<TrickLibrary> pumpLantern(
  WidgetTester tester, {
  List<Trick>? tricks,
  String Function()? nextId,
}) async {
  final seed = tricks ?? starterTricks;
  final library = TrickLibrary(
    repository: MemoryTrickRepository(seed),
    tricks: seed,
  );
  await tester.pumpWidget(LanternApp(library: library, nextId: nextId));
  await tester.pumpAndSettle();
  return library;
}
