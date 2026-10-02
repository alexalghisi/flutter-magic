import 'memory_trick_repository.dart';
import 'starter.dart';
import 'trick_library.dart';

Future<TrickLibrary> openLibrary() async {
  final repository = MemoryTrickRepository(starterTricks);
  return TrickLibrary(repository: repository, tricks: starterTricks);
}
