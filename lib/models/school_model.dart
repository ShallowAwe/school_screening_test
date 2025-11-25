/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var mySchoolNode = School.fromJson(map);
*/
import 'package:intl/intl.dart';

class SchoolDetails {
  String? schoolName;
  String? schoolCode;
  String? schoolType;
  String? schoolPrincipalName;
  String? schoolContactNumber;
  String? SchoolAddress;
  int? districtId;
  String? districtName;
  int? talukaId;
  String? talukaName;
  int? grampanchayatId;
  String? grampanchayatName;
  bool? anganwadi;
  bool? miniAnganwadi;
  bool? firstClass;
  bool? secondClass;
  bool? thirdClass;
  bool? fourthClass;
  bool? fifthClass;
  bool? sixthClass;
  bool? seventhClass;
  bool? eighthClass;
  bool? ninethClass;
  bool? tenthClass;
  bool? eleventhClass;
  bool? twelthClass;
  int? totalNoOFBoys;
  int? totalNoOfGirls;
  int? total;
  String? latitude;
  String? longitude;
  String? SchoolPhoto;
  int? TeamId;
  bool? nationalDeworingProgram;
  bool? anemiaMuktaBharat;
  bool? vitASupplementationProgram;
  DateTime? VisitDate;

  SchoolDetails({
    this.SchoolAddress,
    this.schoolName,
    this.schoolType,
    this.schoolCode,
    this.schoolPrincipalName,
    this.schoolContactNumber,
    this.districtId,
    this.districtName,
    this.talukaId,
    this.talukaName,
    this.grampanchayatId,
    this.grampanchayatName,
    this.anganwadi,
    this.miniAnganwadi,
    this.firstClass,
    this.secondClass,
    this.thirdClass,
    this.fourthClass,
    this.fifthClass,
    this.sixthClass,
    this.seventhClass,
    this.eighthClass,
    this.ninethClass,
    this.tenthClass,
    this.eleventhClass,
    this.twelthClass,
    this.totalNoOFBoys,
    this.totalNoOfGirls,
    this.total,
    this.latitude,
    this.longitude,
    this.SchoolPhoto,
    this.TeamId,
    this.nationalDeworingProgram,
    this.anemiaMuktaBharat,
    this.VisitDate,
    this.vitASupplementationProgram,
  });

  SchoolDetails.fromJson(Map<String, dynamic> json) {
    schoolType = json['schoolType'];
    SchoolAddress = json['address'];
    schoolName = json['schoolName'];
    schoolCode = json['schoolCode'];
    schoolPrincipalName = json['schoolPrincipalName'];
    schoolContactNumber = json['schoolContactNo'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    VisitDate = json['visitDate'];
    talukaId = json['talukaId'];
    talukaName = json['talukaName'];
    grampanchayatId = json['grampanchayatId'];
    grampanchayatName = json['grampanchayatName'];
    anganwadi = json['anganwadi'];
    miniAnganwadi = json['miniAnganwadi'];
    firstClass = json['firstClass'];
    secondClass = json['secondClass'];
    thirdClass = json['thirdClass'];
    fourthClass = json['fourthClass'];
    fifthClass = json['fifthClass'];
    sixthClass = json['sixthClass'];
    seventhClass = json['seventhClass'];
    eighthClass = json['eighthClass'];
    ninethClass = json['ninethClass'];
    tenthClass = json['tenthClass'];
    eleventhClass = json['eleventhClass'];
    twelthClass = json['twelthClass'];
    totalNoOFBoys = json['totalNoOFBoys'];
    totalNoOfGirls = json['totalNoOfGirls'];
    total = json['total'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    SchoolPhoto = json['SchoolPhoto'];
    TeamId = json['DoctorId'];
    nationalDeworingProgram = json['nationalDeworingProgram'];
    anemiaMuktaBharat = json['anemiaMuktaBharat'];
    vitASupplementationProgram = json['vitASupplementationProgram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SchoolType'] = schoolType;
    data['schoolName'] = schoolName;
    data['SchoolAddress'] = SchoolAddress;
    data['schoolCode'] = schoolCode;
    data['schoolPrincipalName'] = schoolPrincipalName;
    data['SchoolContactNumber'] = schoolContactNumber;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['talukaId'] = talukaId;
    data['talukaName'] = talukaName;
    data['grampanchayatId'] = grampanchayatId;
    data['grampanchayatName'] = grampanchayatName;
    data['anganwadi'] = anganwadi;
    data['miniAnganwadi'] = miniAnganwadi;
    data['firstClass'] = firstClass;
    data['secondClass'] = secondClass;
    data['thirdClass'] = thirdClass;
    data['fourthClass'] = fourthClass;
    data['fifthClass'] = fifthClass;
    data['sixthClass'] = sixthClass;
    data['seventhClass'] = seventhClass;
    data['eighthClass'] = eighthClass;
    data['ninethClass'] = ninethClass;
    data['tenthClass'] = tenthClass;
    data['eleventhClass'] = eleventhClass;
    data['twelthClass'] = twelthClass;
    data['totalNoOFBoys'] = totalNoOFBoys;
    data['totalNoOfGirls'] = totalNoOfGirls;
    data['total'] = total;

    data['latitude'] = latitude;
    data['longitude'] = longitude;

    // Add visitDate here
    data['visitDate'] = VisitDate != null
        ? DateFormat('yyyy-MM-dd').format(VisitDate!)
        : null;

    data['SchoolPhoto'] = SchoolPhoto;
    data['TeamId'] = TeamId;
    data['nationalDeworingProgram'] = nationalDeworingProgram;
    data['anemiaMuktaBharat'] = anemiaMuktaBharat;
    data['vitASupplementationProgram'] = vitASupplementationProgram;
    return data;
  }
}
