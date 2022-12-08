import './Account.dart';

class Userinfo {
    String? portrait;
    String account;
    List<Account?>? accounts;
    String name;

    Userinfo({required this.account, this.portrait,this.accounts, required this.name});

    factory Userinfo.fromJson(Map<String, dynamic> json) {
        return Userinfo(
            account: json['account'],
            portrait: json['portrait'],
            accounts: json['accounts'] != null ? (json['accounts'] as List).map((i) => Account.fromJson(i)).toList() : null, 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['account'] = this.account;
        data['portrait'] = this.portrait;
        data['name'] = this.name;
        if (this.accounts != null) {
            data['accounts'] = this.accounts?.map((v) => v?.toJson()).toList();
        }
        return data;
    }
}