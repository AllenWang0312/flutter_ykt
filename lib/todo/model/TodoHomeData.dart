import './stract/group.dart';
import './stract/Userinfo.dart';

class TodoHomeData {
    List<Group>? def;
    List<Group>? personal;
    Userinfo? userinfo;

    TodoHomeData({required this.def, required this.personal, required this.userinfo});

    factory TodoHomeData.fromJson(Map<String, dynamic> json) {
        return TodoHomeData(
            def: json['def'] != null ? (json['def'] as List).map((i) => Group.fromJson(i)).toList() : null,
            personal: json['personal'] != null ? (json['personal'] as List).map((i) => Group.fromJson(i)).toList() : null,
            userinfo: json['userinfo'] != null ? Userinfo.fromJson(json['userinfo']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.def != null) {
            data['def'] = this.def?.map((v) => v.toJson()).toList();
        }
        if (this.personal != null) {
            data['personal'] = this.personal?.map((v) => v.toJson()).toList();
        }
        if (this.userinfo != null) {
            data['userinfo'] = this.userinfo?.toJson();
        }
        return data;
    }
}