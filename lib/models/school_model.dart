class School {
  final int? schoolId;
  final String schoolName;
  final String schoolCode;
  final String schoolPrincipalName;
  final String schoolContactNo;
  final int districtId;
  final String districtName;
  final int talukaId;
  final String talukaName;
  final int grampanchayatId;
  final String grampanchayatName;
  final bool anganwadi;
  final bool miniAnganwadi;
  final bool firstClass;
  final bool secondClass;
  final bool thirdClass;
  final bool fourthClass;
  final bool fifthClass;
  final bool sixthClass;
  final bool seventhClass;
  final bool eighthClass;
  final bool ninethClass;
  final bool tenthClass;
  final bool eleventhClass;
  final bool twelthClass;
  final int totalNoOFBoys;
  final int totalNoOfGirls;
  final int total;
  final String latitude;
  final String longitude;
  final String schoolPhoto;
  final int userId;
  final bool nationalDeworingProgram;
  final bool anemiaMuktaBharat;
  final bool vitASupplementationProgram;

  School({
    this.schoolId,
    required this.schoolName,
    required this.schoolCode,
    required this.schoolPrincipalName,
    required this.schoolContactNo,
    required this.districtId,
    required this.districtName,
    required this.talukaId,
    required this.talukaName,
    required this.grampanchayatId,
    required this.grampanchayatName,
    required this.anganwadi,
    required this.miniAnganwadi,
    required this.firstClass,
    required this.secondClass,
    required this.thirdClass,
    required this.fourthClass,
    required this.fifthClass,
    required this.sixthClass,
    required this.seventhClass,
    required this.eighthClass,
    required this.ninethClass,
    required this.tenthClass,
    required this.eleventhClass,
    required this.twelthClass,
    required this.totalNoOFBoys,
    required this.totalNoOfGirls,
    required this.total,
    required this.latitude,
    required this.longitude,
    required this.schoolPhoto,
    required this.userId,
    required this.nationalDeworingProgram,
    required this.anemiaMuktaBharat,
    required this.vitASupplementationProgram,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      schoolCode: json['schoolCode'],
      schoolPrincipalName: json['schoolPrincipalName'],
      schoolContactNo: json['schoolContactNo'],
      districtId: json['districtId'],
      districtName: json['districtName'],
      talukaId: json['talukaId'],
      talukaName: json['talukaName'],
      grampanchayatId: json['grampanchayatId'],
      grampanchayatName: json['grampanchayatName'],
      anganwadi: json['anganwadi'],
      miniAnganwadi: json['miniAnganwadi'],
      firstClass: json['firstClass'],
      secondClass: json['secondClass'],
      thirdClass: json['thirdClass'],
      fourthClass: json['fourthClass'],
      fifthClass: json['fifthClass'],
      sixthClass: json['sixthClass'],
      seventhClass: json['seventhClass'],
      eighthClass: json['eighthClass'],
      ninethClass: json['ninethClass'],
      tenthClass: json['tenthClass'],
      eleventhClass: json['eleventhClass'],
      twelthClass: json['twelthClass'],
      totalNoOFBoys: json['totalNoOFBoys'],
      totalNoOfGirls: json['totalNoOfGirls'],
      total: json['total'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      schoolPhoto: json['schoolPhoto'],
      userId: json['userId'],
      nationalDeworingProgram: json['nationalDeworingProgram'],
      anemiaMuktaBharat: json['anemiaMuktaBharat'],
      vitASupplementationProgram: json['vitASupplementationProgram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (schoolId != null) 'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolPrincipalName': schoolPrincipalName,
      'schoolContactNo': schoolContactNo,
      'districtId': districtId,
      'districtName': districtName,
      'talukaId': talukaId,
      'talukaName': talukaName,
      'grampanchayatId': grampanchayatId,
      'grampanchayatName': grampanchayatName,
      'anganwadi': anganwadi,
      'miniAnganwadi': miniAnganwadi,
      'firstClass': firstClass,
      'secondClass': secondClass,
      'thirdClass': thirdClass,
      'fourthClass': fourthClass,
      'fifthClass': fifthClass,
      'sixthClass': sixthClass,
      'seventhClass': seventhClass,
      'eighthClass': eighthClass,
      'ninethClass': ninethClass,
      'tenthClass': tenthClass,
      'eleventhClass': eleventhClass,
      'twelthClass': twelthClass,
      'totalNoOFBoys': totalNoOFBoys,
      'totalNoOfGirls': totalNoOfGirls,
      'total': total,
      'latitude': latitude,
      'longitude': longitude,
      'schoolPhoto': schoolPhoto,
      'userId': userId,
      'nationalDeworingProgram': nationalDeworingProgram,
      'anemiaMuktaBharat': anemiaMuktaBharat,
      'vitASupplementationProgram': vitASupplementationProgram,
    };
  }
}