import 'package:flutter/material.dart';

import 'theme.dart';
import 'trick.dart';
import 'trick_library.dart';
import 'trick_page.dart';

class ShelfPage extends StatelessWidget {
  const ShelfPage({required this.library, this.nextId, super.key});

  final TrickLibrary library;
  final String Function()? nextId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        final tricks = library.tricks;
        return Scaffold(
          backgroundColor: ink,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _open(context, _blank(), fresh: true),
            icon: const Icon(Icons.add),
            label: const Text('New trick'),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Masthead(),
                Expanded(
                  child: tricks.isEmpty
                      ? const _EmptyShelf()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                          itemCount: tricks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final trick = tricks[index];
                            return _TrickTile(
                              key: ValueKey(trick.id),
                              trick: trick,
                              onTap: () => _open(context, trick, fresh: false),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Trick _blank() {
    final id =
        nextId?.call() ?? 'trick-${DateTime.now().microsecondsSinceEpoch}';
    return Trick(id: id, title: '', effect: '', method: '', beats: const []);
  }

  Future<void> _open(BuildContext context, Trick trick, {required bool fresh}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) {
          return TrickPage(
            trick: trick,
            onSave: (next) async {
              await library.upsert(next);
              if (routeContext.mounted) Navigator.pop(routeContext);
            },
            onDelete: fresh
                ? null
                : () async {
                    await library.remove(trick.id);
                    if (routeContext.mounted) Navigator.pop(routeContext);
                  },
          );
        },
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LANTERN',
            style: TextStyle(fontSize: 13, letterSpacing: 3.2, color: amber),
          ),
          SizedBox(height: 6),
          Text(
            'Shelf',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: paper,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Effects in the open. Methods covered until you ask.',
            style: TextStyle(color: muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing on the shelf yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: paper,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Write an effect, keep the method covered, and rehearse it before the show.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _TrickTile extends StatelessWidget {
  const _TrickTile({required this.trick, required this.onTap, super.key});

  final Trick trick;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = trick.beats.length;
    final beatLabel = count == 1 ? '1 beat' : '$count beats';
    return Material(
      color: const Color(0xFF2A221B),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3C3128)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trick.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                trick.effect,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                beatLabel,
                style: const TextStyle(color: amber, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
