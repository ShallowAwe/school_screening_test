class User {
  final int userId;
  final String username;
  final String email;
  final String mobile;
  final String position;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.mobile,
    required this.position,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      mobile: json['mobile'],
      position: json['position'],
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'mobile': mobile,
      'position': position,
    };
  }
}