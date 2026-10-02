import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/bootstrap_stub.dart'
    if (dart.library.io) 'src/bootstrap_io.dart'
    if (dart.library.html) 'src/bootstrap_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final library = await openLibrary();
  runApp(LanternApp(library: library));
}
