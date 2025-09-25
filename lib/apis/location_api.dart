import 'package:school_test/models/taluka_model.dart';
import 'package:school_test/utils/api_client.dart';
import '../config/endpoints.dart';


class LocationApi {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> fetchDistricts() async {
    final response = await _apiClient.get(Endpoints.getDistrict);
    return response;
  }

  Future<List<Taluka>> fetchTalukas(int districtId) async {
    final response = await _apiClient.get(
      Endpoints.getTaluka,
      queryParams: {'districtId': districtId.toString()},
    );
    // Map JSON to Taluka model
    List<Taluka> talukas = (response as List)
        .map((json) => Taluka.fromJson(json))
        .toList();
    return talukas;
  }

  Future<List<dynamic>> fetchGrampanchayats(int talukaId) async {
    final response = await _apiClient.get(
      '/api/Rbsk/GetGrampanchayatByTalukaId',
      queryParams: {'talukaId': talukaId.toString()},
    );
    return response;
  }
}
