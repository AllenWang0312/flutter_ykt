import './stract/group.dart';
import './stract/Item.dart';

class GroupDetail {
  late Group info;
  List<Item>? items;
  List<Item>? finished;

  GroupDetail({
    required this.info,
      this.items,
  });

  GroupDetail.fromJson(dynamic json) {
    info = Group.fromJson(json['info']);
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
    if (json['finished'] != null) {
      finished = [];
      json['finished'].forEach((v) {
        finished!.add(Item.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (finished != null) {
      map['finished'] = finished!.map((v) => v.toJson()).toList();
    }
    map['info'] = info.toJson();
    return map;
  }

}