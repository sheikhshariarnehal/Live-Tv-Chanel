/// Data model for system announcements
class Announcement {
  final String id;
  final String title;
  final String body;
  final String type; // 'info', 'warning', 'error'
  final bool active;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'info',
    this.active = true,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'info',
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
