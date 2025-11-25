class ApiResponse<T> {
  final int? responseCode;
  final bool? success;
  final String? responseMessage;
  final String? message;
  final T? data;
  final List<T>? schools;

  ApiResponse({
    this.responseCode,
    this.success,
    this.responseMessage,
    this.message,
    this.data,
    this.schools,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT, {
    String dataKey = 'data', // Allow custom data key
  }) {
    return ApiResponse<T>(
      responseCode: json['responseCode'],
      success: json['success'],
      responseMessage: json['responseMessage'],
      message: json['message'],
      data: json[dataKey] != null && fromJsonT != null
          ? fromJsonT(json[dataKey])
          : json[dataKey],
      schools: json['schools'] != null && fromJsonT != null
          ? (json['schools'] as List).map((e) => fromJsonT(e)).toList()
          : json['schools'],
    );
  }
}
