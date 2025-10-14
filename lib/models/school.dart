class School {
  final int schoolId;
  final String schoolName;
  final String schoolCode;
  final String flag;

  School({
    required this.schoolId,
    required this.schoolName,
    required this.schoolCode,
    required this.flag,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolCode: json['schoolCode'] ?? '',
      schoolId: json['schoolId'] ?? 0,
      schoolName: json['schoolName'] ?? '',
      flag: json['flag'] ?? '',
    );
  }
}
