class School {
  final int schoolId;
  final String schoolName;
  final String flag;

  School({
    required this.schoolId,
    required this.schoolName,
    required this.flag,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolId: json['schoolId'] ?? 0,
      schoolName: json['schoolName'] ?? '',
      flag: json['flag'] ?? '',
    );
  }
}
