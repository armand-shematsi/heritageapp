import '../models/heritage_site.dart';
import 'api_service.dart';

class HeritageSiteService {
  final ApiService _api = ApiService();

  Future<List<HeritageSite>> getHeritageSites() async {
    try {
      final response = await _api.get('/heritage-sites');
      if (response is List) {
        return response.map((json) => HeritageSite.fromJson(json)).toList();
      } else if (response['data'] != null) {
        return (response['data'] as List)
            .map((json) => HeritageSite.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching heritage sites: $e');
      return [];
    }
  }

  Future<HeritageSite?> getHeritageSite(String id) async {
    try {
      final response = await _api.get('/heritage-sites/$id');
      return HeritageSite.fromJson(response);
    } catch (e) {
      print('Error fetching heritage site: $e');
      return null;
    }
  }

  Future<HeritageSite?> createHeritageSite(HeritageSite site) async {
    try {
      final response = await _api.post('/heritage-sites', {
        'name': site.name,
        'description': site.description,
        'location': site.location,
        'image_url': site.imageUrl,
        'cultural_significance': site.culturalSignificance,
        'latitude': site.latitude,
        'longitude': site.longitude,
      });
      return HeritageSite.fromJson(response);
    } catch (e) {
      print('Error creating heritage site: $e');
      return null;
    }
  }
}

