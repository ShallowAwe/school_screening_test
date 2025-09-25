class District {
  final int districtId;
  final String districtName;

  District({
    required this.districtId,
    required this.districtName,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      districtId: json['districtId'],
      districtName: json['districtName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'districtId': districtId,
      'districtName': districtName,
    };
  }
}