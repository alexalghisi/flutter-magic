import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';

class BeatClock {
  Duration elapsed = Duration.zero;
  var running = false;

  void start() {
    running = true;
  }

  void advance(Duration step) {
    if (!running) return;
    elapsed += step;
  }

  String get label {
    final total = elapsed.inSeconds;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class RehearsalPage extends StatefulWidget {
  const RehearsalPage({required this.title, required this.beats, super.key});

  final String title;
  final List<String> beats;

  @override
  State<RehearsalPage> createState() => _RehearsalPageState();
}

class _RehearsalPageState extends State<RehearsalPage> {
  final BeatClock _clock = BeatClock();
  Timer? _ticker;
  var _index = 0;
  var _live = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _begin() {
    _clock.start();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _clock.advance(const Duration(seconds: 1));
      if (mounted) setState(() {});
    });
    setState(() => _live = true);
  }

  void _back() {
    if (_index == 0) return;
    setState(() => _index -= 1);
  }

  void _forward() {
    if (_index >= widget.beats.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() => _index += 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(child: widget.beats.isEmpty ? _empty() : _liveBeats()),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add a beat before you rehearse.',
              textAlign: TextAlign.center,
              style: TextStyle(color: paper, fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _liveBeats() {
    final last = _index == widget.beats.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _live ? _clock.label : 'Ready',
            key: const Key('rehearsal-clock'),
            style: const TextStyle(
              color: amber,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Beat ${_index + 1} of ${widget.beats.length}',
            style: const TextStyle(color: muted),
          ),
          const SizedBox(height: 28),
          Text(
            widget.beats[_index],
            key: const Key('current-beat'),
            style: const TextStyle(color: paper, fontSize: 28, height: 1.3),
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(
                onPressed: _index == 0 ? null : _back,
                child: const Text('Back'),
              ),
              const Spacer(),
              if (!_live)
                FilledButton(onPressed: _begin, child: const Text('Begin'))
              else
                FilledButton(
                  onPressed: _forward,
                  child: Text(last ? 'Done' : 'Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
