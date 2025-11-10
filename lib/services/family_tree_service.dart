import 'api_service.dart';

class FamilyTreeService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getFamilyTree() async {
    try {
      final response = await _api.get('/family-tree');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error fetching family tree: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> addFamilyMember({
    required String name,
    required String relationship,
    String? birthDate,
    String? deathDate,
    String? notes,
    String? parentId,
  }) async {
    try {
      final response = await _api.post('/family-tree', {
        'name': name,
        'relationship': relationship,
        'birth_date': birthDate,
        'death_date': deathDate,
        'notes': notes,
        'parent_id': parentId,
      });
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error adding family member: $e');
      return null;
    }
  }

  Future<bool> updateFamilyMember(String id, Map<String, dynamic> data) async {
    try {
      await _api.put('/family-tree/$id', data);
      return true;
    } catch (e) {
      print('Error updating family member: $e');
      return false;
    }
  }

  Future<bool> deleteFamilyMember(String id) async {
    try {
      await _api.delete('/family-tree/$id');
      return true;
    } catch (e) {
      print('Error deleting family member: $e');
      return false;
    }
  }
}

