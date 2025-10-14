class Doctor {
  final int doctorId;
  final String doctorName;
  final String email;
  final String doctorMobileNo;
  final String post;

  Doctor({
    required this.doctorId,
    required this.doctorName,
    required this.email,
    required this.doctorMobileNo,
    required this.post,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'],
      doctorName: json['doctorname'],
      email: json['email'],
      doctorMobileNo: json['doctormobileno'],
      post: json['post'],
    );
  }
}
