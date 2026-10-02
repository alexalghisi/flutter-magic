import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lantern/src/file_trick_repository.dart';
import 'package:lantern/src/trick.dart';

void main() {
  test('missing file reads as an empty shelf', () async {
    final dir = await Directory.systemTemp.createTemp('lantern-empty');
    addTearDown(() => dir.delete(recursive: true));
    final repository = FileTrickRepository(File('${dir.path}/tricks.json'));
    expect(await repository.readAll(), isEmpty);
  });

  test('write then read keeps order and beats', () async {
    final dir = await Directory.systemTemp.createTemp('lantern-round');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/nested/tricks.json');
    final tricks = [
      const Trick(
        id: 'a',
        title: 'Amber force',
        effect: 'Named card',
        method: 'Thumb control',
        beats: ['Ask', 'Deal'],
      ),
      const Trick(
        id: 'b',
        title: 'Four quiet',
        effect: 'Four of a kind',
        method: 'False cut',
        beats: ['Show'],
      ),
    ];

    await FileTrickRepository(file).writeAll(tricks);
    final loaded = await FileTrickRepository(file).readAll();
    expect(loaded, tricks);
  });
}
