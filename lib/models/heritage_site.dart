class HeritageSite {
  final String id;
  final String name;
  final String description;
  final String location;
  final String imageUrl;
  final String culturalSignificance;
  final double latitude;
  final double longitude;

  HeritageSite({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.culturalSignificance,
    required this.latitude,
    required this.longitude,
  });

  factory HeritageSite.fromJson(Map<String, dynamic> json) {
    return HeritageSite(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'] ?? '',
      culturalSignificance: json['cultural_significance'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}