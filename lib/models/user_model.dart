class User {
  final int teamId;
  final String teamName;
  final String email;
  final String password;
  final String doctorname;
  User({
    required this.doctorname,
    required this.teamId,
    required this.teamName,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      doctorname: json['doctorName'] ?? '',
      teamId: json['teamId'],
      teamName: json['teamName'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
