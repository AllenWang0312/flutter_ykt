class Group {
  int id;
  String name;
  int? count;
  int? icon;

  Group({required this.id, this.count, required this.icon, required this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      count: json['count'],
      icon: json['icon'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['count'] = this.count;
    data['icon'] = this.icon;
    data['name'] = this.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          count == other.count &&
          icon == other.icon;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ count.hashCode ^ icon.hashCode;
}
