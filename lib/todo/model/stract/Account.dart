class Account {
    String email;
    String? icon;
    String name;

    Account({required this.email, this.icon, required this.name});

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            email: json['email'], 
            icon: json['icon'],
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['email'] = this.email;
        data['icon'] = this.icon;
        data['name'] = this.name;
        return data;
    }
}