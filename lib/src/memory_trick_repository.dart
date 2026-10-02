import 'trick.dart';
import 'trick_repository.dart';

class MemoryTrickRepository implements TrickRepository {
  MemoryTrickRepository([List<Trick>? seed])
    : _tricks = List<Trick>.of(seed ?? const []);

  List<Trick> _tricks;

  @override
  Future<List<Trick>> readAll() async => List<Trick>.unmodifiable(_tricks);

  @override
  Future<void> writeAll(List<Trick> tricks) async {
    _tricks = List<Trick>.of(tricks);
  }
}
