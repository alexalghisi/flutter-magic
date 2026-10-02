import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/memory_trick_repository.dart';
import 'package:lantern/src/trick.dart';
import 'package:lantern/src/trick_library.dart';

Trick sample({String id = 'one', String title = 'Amber force'}) {
  return Trick(
    id: id,
    title: title,
    effect: 'A card arrives.',
    method: 'A control.',
    beats: const ['Ask.', 'Deal.'],
  );
}

void main() {
  test('title is required', () {
    expect(trickTitleError(''), 'Give the trick a title.');
    expect(trickTitleError('   '), 'Give the trick a title.');
    expect(trickTitleError('Cold reading'), isNull);
  });

  test('upsert adds, replaces, and remove drops', () async {
    final repository = MemoryTrickRepository();
    final library = TrickLibrary(repository: repository);
    final first = sample();

    await library.upsert(first);
    expect(library.tricks, [first]);

    final renamed = Trick(
      id: first.id,
      title: 'Amber force II',
      effect: first.effect,
      method: first.method,
      beats: first.beats,
    );
    await library.upsert(renamed);
    expect(library.tricks, [renamed]);
    expect(await repository.readAll(), [renamed]);

    await library.upsert(sample(id: 'two', title: 'Pocket glimpse'));
    await library.remove(first.id);
    expect(library.tricks.map((trick) => trick.id), ['two']);
    expect(await repository.readAll(), library.tricks);
  });
}
