class Disease {
  final int diseaseId;
  final String diseaseName;

  Disease({required this.diseaseId, required this.diseaseName});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['diseaseId'],
      diseaseName: json['diseaseName'],
    );
  }
}

class DiseaseCategoryResponse {
  final int categoryId;
  final String categoryName;
  final List<Disease> diseases;

  DiseaseCategoryResponse({
    required this.categoryId,
    required this.categoryName,
    required this.diseases,
  });

  factory DiseaseCategoryResponse.fromJson(Map<String, dynamic> json) {
    return DiseaseCategoryResponse(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      diseases: (json['diseases'] as List)
          .map((e) => Disease.fromJson(e))
          .toList(),
    );
  }
}
