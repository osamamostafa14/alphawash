class SignUpModel {
  String? fullName;
  String? phone;
  String? address;
  String? email;
  String? password;

  SignUpModel({this.fullName, this.phone,this.address, this.email='', this.password});

  SignUpModel.fromJson(Map<String?, dynamic> json) {
    fullName = json['full_name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
