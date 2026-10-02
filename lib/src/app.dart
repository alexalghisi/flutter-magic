import 'dart:math';

import 'package:flutter/material.dart';

import 'shelf_page.dart';
import 'table_controller.dart';
import 'table_page.dart';
import 'theme.dart';
import 'trick_library.dart';

class LanternApp extends StatelessWidget {
  const LanternApp({
    required this.library,
    this.nextId,
    this.random,
    super.key,
  });

  final TrickLibrary library;
  final String Function()? nextId;
  final Random? random;

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
              child: LanternHome(
                library: library,
                nextId: nextId,
                random: random,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LanternHome extends StatefulWidget {
  const LanternHome({
    required this.library,
    this.nextId,
    this.random,
    super.key,
  });

  final TrickLibrary library;
  final String Function()? nextId;
  final Random? random;

  @override
  State<LanternHome> createState() => _LanternHomeState();
}

class _LanternHomeState extends State<LanternHome> {
  late final TableController _table = TableController(random: widget.random);
  var _section = 0;

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      body: IndexedStack(
        index: _section,
        children: [
          ShelfPage(library: widget.library, nextId: widget.nextId),
          TablePage(controller: _table),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _section,
        onDestinationSelected: (value) => setState(() => _section = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Shelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Table',
          ),
        ],
      ),
    );
  }
}
