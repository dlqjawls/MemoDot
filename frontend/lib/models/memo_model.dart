class MemoModel {
  final String id;
  final String userId;
  final String content;
  final List<String> tags;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemoModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.tags,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      tags: List<String>.from(json['tags'] ?? []),
      isPublic: json['is_public'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'tags': tags,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
