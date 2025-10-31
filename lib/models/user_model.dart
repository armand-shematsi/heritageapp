class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? culturalBackground;
  final String? currentLocation;
  final List<String> languages;
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.culturalBackground,
    this.currentLocation,
    this.languages = const [],
    required this.joinDate,
  });
}