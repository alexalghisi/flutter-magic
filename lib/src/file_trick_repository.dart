import 'dart:convert';
import 'dart:io';

import 'trick.dart';
import 'trick_repository.dart';

class FileTrickRepository implements TrickRepository {
  FileTrickRepository(this._file);

  final File _file;

  @override
  Future<List<Trick>> readAll() async {
    if (!_file.existsSync()) return const [];
    final decoded = jsonDecode(await _file.readAsString()) as List;
    return [
      for (final item in decoded)
        Trick.fromJson(Map<String, Object?>.from(item as Map)),
    ];
  }

  @override
  Future<void> writeAll(List<Trick> tricks) async {
    await _file.parent.create(recursive: true);
    final payload = jsonEncode([for (final trick in tricks) trick.toJson()]);
    await _file.writeAsString(payload);
  }
}
