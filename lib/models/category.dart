/// Data model for channel category
class Category {
  final String id;
  final String name;
  final String? icon;
  final int sortOrder;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}
