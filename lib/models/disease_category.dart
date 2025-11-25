class DiseaseCategory {
  final String categoryId;
  final String categoryName;

  DiseaseCategory({required this.categoryId, required this.categoryName});

  factory DiseaseCategory.fromJson(Map<String, dynamic> json) {
    return DiseaseCategory(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'categoryId': categoryId, 'categoryName': categoryName};
  }
}
