class Hospital {
  final int hospitalId;
  final String hospitalName;
  final String hospitalType;
  final String email;
  final int talukaId;
  final String talukaName;

  Hospital({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalType,
    required this.email,
    required this.talukaId,
    required this.talukaName,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
    hospitalId: json['hospitalId'],
    hospitalName: json['hospitalName'],
    hospitalType: json['hospitalType'],
    email: json['email'],
    talukaId: json['talukaId'],
    talukaName: json['talukaName'],
  );

  Map<String, dynamic> toJson() => {
    'hospitalId': hospitalId,
    'hospitalName': hospitalName,
    'hospitalType': hospitalType,
    'email': email,
    'talukaId': talukaId,
    'talukaName': talukaName,
  };
}
