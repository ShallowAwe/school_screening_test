class Grampanchayat {
  final int grampanchayatId;
  final int talukaId;
  final String grampanchayatName;

  Grampanchayat({
    required this.grampanchayatId,
    required this.talukaId,
    required this.grampanchayatName,
  });

  factory Grampanchayat.fromJson(Map<String, dynamic> json) {
    return Grampanchayat(
      grampanchayatId: json['grampanchayatId'],
      talukaId: json['talukaId'],
      grampanchayatName: json['grampanchayatName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grampanchayatId': grampanchayatId,
      'talukaId': talukaId,
      'grampanchayatName': grampanchayatName,
    };
  }
}
