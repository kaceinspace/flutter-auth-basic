class UserModel {
  final String name;
  final String email;

  UserModel({required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['email'], name: json['name']);
  }
}
