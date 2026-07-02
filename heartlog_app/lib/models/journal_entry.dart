class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String? audioPath;
  final int durationSeconds;
  final String mood;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    this.audioPath,
    this.durationSeconds = 0,
    required this.mood,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? audioPath,
    int? durationSeconds,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      audioPath: audioPath ?? this.audioPath,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'audioPath': audioPath,
      'durationSeconds': durationSeconds,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      audioPath: map['audioPath'] as String?,
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      mood: map['mood'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
    );
  }
}
