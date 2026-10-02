import 'package:flutter/foundation.dart';

import 'trick.dart';
import 'trick_repository.dart';

class TrickLibrary extends ChangeNotifier {
  TrickLibrary({required this.repository, List<Trick> tricks = const []})
    : _tricks = List<Trick>.of(tricks);

  final TrickRepository repository;
  List<Trick> _tricks;

  List<Trick> get tricks => List<Trick>.unmodifiable(_tricks);

  Future<void> upsert(Trick trick) async {
    final next = List<Trick>.of(_tricks);
    final index = next.indexWhere((item) => item.id == trick.id);
    if (index == -1) {
      next.add(trick);
    } else {
      next[index] = trick;
    }
    _tricks = next;
    await repository.writeAll(_tricks);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _tricks = [
      for (final item in _tricks)
        if (item.id != id) item,
    ];
    await repository.writeAll(_tricks);
    notifyListeners();
  }
}
