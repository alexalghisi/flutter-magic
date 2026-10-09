import 'package:flutter/material.dart';

import 'theme.dart';
import 'trick.dart';
import 'rehearsal_page.dart';

class TrickPage extends StatefulWidget {
  const TrickPage({
    required this.trick,
    required this.onSave,
    this.onDelete,
    super.key,
  });

  final Trick trick;
  final Future<void> Function(Trick trick) onSave;
  final Future<void> Function()? onDelete;

  @override
  State<TrickPage> createState() => _TrickPageState();
}

class _TrickPageState extends State<TrickPage> {
  late final TextEditingController _title;
  late final TextEditingController _effect;
  late final TextEditingController _method;
  late final List<TextEditingController> _beats;
  String? _error;
  var _methodOpen = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.trick.title);
    _effect = TextEditingController(text: widget.trick.effect);
    _method = TextEditingController(text: widget.trick.method);
    _beats = [
      for (final beat in widget.trick.beats) TextEditingController(text: beat),
    ];
  }

  @override
  void dispose() {
    _title.dispose();
    _effect.dispose();
    _method.dispose();
    for (final beat in _beats) {
      beat.dispose();
    }
    super.dispose();
  }

  Trick _current() {
    return Trick(
      id: widget.trick.id,
      title: _title.text.trim(),
      effect: _effect.text.trim(),
      method: _method.text.trim(),
      beats: [
        for (final beat in _beats)
          if (beat.text.trim().isNotEmpty) beat.text.trim(),
      ],
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final error = trickTitleError(_title.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    await widget.onSave(_current());
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _confirmRemove() async {
    final remove = widget.onDelete;
    if (remove == null) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove this trick?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    if (yes == true) await remove();
  }

  void _addBeat() {
    setState(() => _beats.add(TextEditingController()));
  }

  void _dropBeat(int index) {
    final controller = _beats.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  void _rehearse() {
    final title = _title.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RehearsalPage(
          title: title.isEmpty ? 'Untitled' : title,
          beats: [
            for (final beat in _beats)
              if (beat.text.trim().isNotEmpty) beat.text.trim(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fresh = widget.trick.title.isEmpty;
    return Scaffold(
      backgroundColor: ink,
      appBar: AppBar(
        title: Text(fresh ? 'New trick' : 'Trick'),
        actions: [
          if (widget.onDelete != null)
            IconButton(
              key: const Key('remove-trick'),
              tooltip: 'Remove trick',
              onPressed: _confirmRemove,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              TextButton(
                key: const Key('rehearse-trick'),
                onPressed: _rehearse,
                child: const Text('Rehearse'),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('save-trick'),
                onPressed: _saving ? null : _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            TextField(
              key: const Key('trick-title'),
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  _error!,
                  key: const Key('title-error'),
                  style: const TextStyle(color: Color(0xFFE07A68)),
                ),
              ),
            const SizedBox(height: 14),
            TextField(
              key: const Key('trick-effect'),
              controller: _effect,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Effect',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            if (!_methodOpen)
              OutlinedButton(
                onPressed: () => setState(() => _methodOpen = true),
                child: const Text('Uncover method'),
              )
            else
              TextField(
                key: const Key('trick-method'),
                controller: _method,
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Method',
                  alignLabelWithHint: true,
                ),
              ),
            if (!_methodOpen)
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  'Method stays covered.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ),
            const SizedBox(height: 22),
            const Text(
              'Beats',
              style: TextStyle(color: paper, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _beats.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      key: Key('beat-$i'),
                      controller: _beats[i],
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(labelText: 'Beat ${i + 1}'),
                    ),
                  ),
                  IconButton(
                    key: Key('drop-beat-$i'),
                    tooltip: 'Drop beat',
                    onPressed: () => _dropBeat(i),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const Key('add-beat'),
                onPressed: _addBeat,
                child: const Text('Add beat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
