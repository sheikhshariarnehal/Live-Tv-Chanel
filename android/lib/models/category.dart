/// Data model for channel category
class Category {
  final String id;
  final String name;
  final String? icon;
  final String? iconUrl;
  final int sortOrder;
  final bool active;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.iconUrl,
    this.sortOrder = 0,
    this.active = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      iconUrl: json['icon_url'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'icon_url': iconUrl,
        'sort_order': sortOrder,
        'active': active,
      };
}
