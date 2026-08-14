class RepositoryModel {
  final String name;
  final String? description;
  final int stars;
  final String? language;
  final DateTime? updatedAt;

  RepositoryModel({
    required this.name,
    this.description,
    required this.stars,
    this.language,
    this.updatedAt,
  });

  factory RepositoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RepositoryModel(
      name: json['name'] ?? '',
      description: json['description'],
      stars: json['stargazers_count'] ?? 0,
      language: json['language'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(
              json['updated_at'],
            )
          : null,
    );
  }
}