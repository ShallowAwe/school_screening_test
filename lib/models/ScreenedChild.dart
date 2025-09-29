class ScreenedChild {
  final String createdDate;
  final String childName;
  final String fathersName;
  final String fathersContactNo;

  ScreenedChild({
    required this.createdDate,
    required this.childName,
    required this.fathersName,
    required this.fathersContactNo,
  });

  factory ScreenedChild.fromJson(Map<String, dynamic> json) {
    return ScreenedChild(
      createdDate: json['createdDate'] ?? '',
      childName: json['childName'] ?? '',
      fathersName: json['fathersName'] ?? '',
      fathersContactNo: json['fathersContactNo'] ?? '',
    );
  }
}
