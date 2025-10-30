class Team {
  final int teamId;
  final String teamName;
  final String email;
  final String password;

  Team({
    required this.teamId,
    required this.teamName,
    required this.email,
    required this.password,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
      teamName: json['teamName'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
