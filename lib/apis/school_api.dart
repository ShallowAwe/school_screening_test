import 'package:school_test/models/school_model.dart';
import 'package:school_test/utils/api_client.dart';
import '../config/endpoints.dart';


class SchoolApi {
  final ApiClient _apiClient = ApiClient();

  Future<School> getSchool(int schoolId) async {
    final response = await _apiClient.get(
      Endpoints.getSchool,
      queryParams: {'schoolId': schoolId.toString()},
    );
    return School.fromJson(response);
  }

/// it need to adjusted according to other apis  
  Future<School> addSchool(School school) async {
    final response = await _apiClient.post(
      Endpoints.addSchool,
      body: school.toJson(),
    );
    return School.fromJson(response);
  }
}
