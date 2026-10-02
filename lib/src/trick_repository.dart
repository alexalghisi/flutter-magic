import 'trick.dart';

abstract class TrickRepository {
  Future<List<Trick>> readAll();

  Future<void> writeAll(List<Trick> tricks);
}
