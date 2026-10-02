class Trick {
  const Trick({
    required this.id,
    required this.title,
    required this.effect,
    required this.method,
    required this.beats,
  });

  final String id;
  final String title;
  final String effect;
  final String method;
  final List<String> beats;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'effect': effect,
      'method': method,
      'beats': beats,
    };
  }

  factory Trick.fromJson(Map<String, Object?> json) {
    return Trick(
      id: json['id'] as String,
      title: json['title'] as String,
      effect: json['effect'] as String,
      method: json['method'] as String,
      beats: (json['beats'] as List).cast<String>(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Trick) return false;
    if (other.id != id ||
        other.title != title ||
        other.effect != effect ||
        other.method != method ||
        other.beats.length != beats.length) {
      return false;
    }
    for (var i = 0; i < beats.length; i++) {
      if (other.beats[i] != beats[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, effect, method, Object.hashAll(beats));
}

String? trickTitleError(String value) {
  if (value.trim().isEmpty) return 'Give the trick a title.';
  return null;
}
