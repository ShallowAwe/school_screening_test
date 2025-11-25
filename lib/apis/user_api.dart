import 'package:school_test/models/user_model.dart';
import 'package:school_test/utils/api_client.dart';

import '../config/endpoints.dart';

class UserApi {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> login(String email, String password) async {
    final User user = await _apiClient.post(
      Endpoints.userLogin,
      body: {'email': email, 'password': password},
    );
    return user;
  }
}
