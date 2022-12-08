class BannerResponse {
  int? status;
  List<Data>? data;

  BannerResponse({this.status, this.data});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? imageurl;
  String? linkurl;
  String? alt;
  int? type;

  Data({this.imageurl, this.linkurl, this.alt, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    imageurl = json['imageurl'];
    linkurl = json['linkurl'];
    alt = json['alt'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageurl'] = this.imageurl;
    data['linkurl'] = this.linkurl;
    data['alt'] = this.alt;
    data['type'] = this.type;
    return data;
  }
}