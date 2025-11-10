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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      culturalBackground: json['cultural_background'],
      currentLocation: json['current_location'],
      languages: json['languages'] != null 
          ? List<String>.from(json['languages'])
          : [],
      joinDate: json['join_date'] != null
          ? DateTime.parse(json['join_date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'cultural_background': culturalBackground,
      'current_location': currentLocation,
      'languages': languages,
      'join_date': joinDate.toIso8601String(),
    };
  }
}