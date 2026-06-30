class Task {
  final String id;
  final DateTime createdAt;
  final String title;
  final String? description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.createdAt,
    required this.title,
    this.description,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: map['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
