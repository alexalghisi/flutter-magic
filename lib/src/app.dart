import 'package:flutter/material.dart';

import 'shelf_page.dart';
import 'theme.dart';
import 'trick_library.dart';

class LanternApp extends StatelessWidget {
  const LanternApp({required this.library, this.nextId, super.key});

  final TrickLibrary library;
  final String Function()? nextId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lantern',
      debugShowCheckedModeBanner: false,
      theme: lanternTheme(),
      home: RepaintBoundary(
        key: const Key('stage'),
        child: ColoredBox(
          color: stage,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ShelfPage(library: library, nextId: nextId),
            ),
          ),
        ),
      ),
    );
  }
}
