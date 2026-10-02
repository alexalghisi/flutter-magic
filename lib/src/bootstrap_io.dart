import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'file_trick_repository.dart';
import 'starter.dart';
import 'trick_library.dart';

Future<TrickLibrary> openLibrary() async {
  final dir = await getApplicationSupportDirectory();
  final file = File('${dir.path}/tricks.json');
  final repository = FileTrickRepository(file);
  if (!file.existsSync()) {
    await repository.writeAll(starterTricks);
  }
  final tricks = await repository.readAll();
  return TrickLibrary(repository: repository, tricks: tricks);
}
