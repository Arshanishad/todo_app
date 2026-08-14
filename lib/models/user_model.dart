class UserModel {
  final String username;
  final String? name;
  final String? bio;
  final String avatarUrl;
  final int followers;
  final int following;
  final int publicRepos;

  UserModel({
    required this.username,
    this.name,
    this.bio,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['login'] ?? '',
      name: json['name'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      publicRepos: json['public_repos'] ?? 0,
    );
  }
}