class Taluka {
  final int talukaId;
  final int districtId;
  final String talukaName;

  Taluka({
    required this.talukaId,
    required this.districtId,
    required this.talukaName,
  });

  factory Taluka.fromJson(Map<String, dynamic> json) {
    return Taluka(
      talukaId: json['talukaId'],
      districtId: json['districtId'],
      talukaName: json['talukaName'],
    );
  }
   
  Map<String, dynamic> toJson() {
    return {
      'talukaId': talukaId,
      'districtId': districtId,
      'talukaName': talukaName,
    };
  }
  }
