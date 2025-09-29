/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var mySchoolNode = School.fromJson(map);
*/ 
class SchoolDetails {
    String? schoolName;
    String? schoolCode;
    String? schoolPrincipalName;
    String? schoolContactNo;
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
    String? schoolPhoto;
    int? userId;
    bool? nationalDeworingProgram;
    bool? anemiaMuktaBharat;
    bool? vitASupplementationProgram;

    SchoolDetails({this.schoolName, this.schoolCode, this.schoolPrincipalName, this.schoolContactNo, this.districtId, this.districtName, this.talukaId, this.talukaName, this.grampanchayatId, this.grampanchayatName, this.anganwadi, this.miniAnganwadi, this.firstClass, this.secondClass, this.thirdClass, this.fourthClass, this.fifthClass, this.sixthClass, this.seventhClass, this.eighthClass, this.ninethClass, this.tenthClass, this.eleventhClass, this.twelthClass, this.totalNoOFBoys, this.totalNoOfGirls, this.total, this.latitude, this.longitude, this.schoolPhoto, this.userId, this.nationalDeworingProgram, this.anemiaMuktaBharat, this.vitASupplementationProgram}); 

    SchoolDetails.fromJson(Map<String, dynamic> json) {
        schoolName = json['schoolName'];
        schoolCode = json['schoolCode'];
        schoolPrincipalName = json['schoolPrincipalName'];
        schoolContactNo = json['schoolContactNo'];
        districtId = json['districtId'];
        districtName = json['districtName'];
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
        latitude = json['latitude'];
        longitude = json['longitude'];
        schoolPhoto = json['schoolPhoto'];
        userId = json['userId'];
        nationalDeworingProgram = json['nationalDeworingProgram'];
        anemiaMuktaBharat = json['anemiaMuktaBharat'];
        vitASupplementationProgram = json['vitASupplementationProgram'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = Map<String, dynamic>();
        data['schoolName'] = schoolName;
        data['schoolCode'] = schoolCode;
        data['schoolPrincipalName'] = schoolPrincipalName;
        data['schoolContactNo'] = schoolContactNo;
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
        data['schoolPhoto'] = schoolPhoto;
        data['userId'] = userId;
        data['nationalDeworingProgram'] = nationalDeworingProgram;
        data['anemiaMuktaBharat'] = anemiaMuktaBharat;
        data['vitASupplementationProgram'] = vitASupplementationProgram;
        return data;
    }
}

