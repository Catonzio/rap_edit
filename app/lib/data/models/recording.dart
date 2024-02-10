class Recording {
  final String id;
  final String name;
  final String path;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Recording({
    required this.id,
    required this.name,
    required this.path,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}
