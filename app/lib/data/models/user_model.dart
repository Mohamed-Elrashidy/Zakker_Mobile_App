import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.email, required super.password, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'], password: json['password'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = email;
    json['password'] = password;
    json['name'] = name;
    return json;
  }
}
