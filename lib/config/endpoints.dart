class Endpoints {
  static const String getSchool = '/api/Rbsk/GetSchool';
  static const String addSchool = '/api/Rbsk/AddSchool';
  static const String userLogin = '/api/Rbsk/UserLogin';
  static const String doctorLogin = '/api/Rbsk/DoctorLogin';
  static const String teamLogin = '/api/Rbsk/TeamLogin';
  static const String getDistrict = '/api/Rbsk/GetDistrict';
  static const String getTaluka = '/api/Rbsk/GetTalukaByDistrictId';
  static const String getGrampanchayat = '/api/Rbsk/GetGrampanchyatByTalukaId';
  static const String schoolByGrampanchayatId =
      '/api/Rbsk/GetSchoolByGrampanchayatId';
  static const String addScreeningSchool = '/api/Rbsk/AddScreeningSchool';
  static const String createStudent = '/api/Rbsk/CreateStudent';
  // Add other endpoints from the collection as needed
}
