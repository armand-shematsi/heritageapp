import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _searchCategories = [
    {'icon': Icons.people, 'title': 'Community Members', 'color': Colors.blue},
    {'icon': Icons.family_restroom, 'title': 'Family Trees', 'color': Colors.green},
    {'icon': Icons.landscape, 'title': 'Heritage Sites', 'color': Colors.orange},
    {'icon': Icons.event, 'title': 'Cultural Events', 'color': Colors.purple},
    {'icon': Icons.forum, 'title': 'Discussions', 'color': Colors.red},
    {'icon': Icons.library_books, 'title': 'Cultural Resources', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Heritage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search heritage sites, people, traditions...',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Search Categories or Results
          if (_searchQuery.isEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Browse Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _searchCategories.length,
                itemBuilder: (context, index) {
                  final category = _searchCategories[index];
                  return _SearchCategoryCard(
                    icon: category['icon'] as IconData,
                    title: category['title'] as String,
                    color: category['color'] as Color,
                  );
                },
              ),
            ),
          ] else ...[
            // Search Results
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Results',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                  ),
                  Text(
                    '${_getSearchResults().length} results',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _getSearchResults();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _SearchResultItem(
          title: result['title'] ?? 'Unknown',
          subtitle: result['subtitle'] ?? '',
          type: result['type'] ?? 'General',
        );
      },
    );
  }

  List<Map<String, dynamic>> _getSearchResults() {
    if (_searchQuery.isEmpty) return [];

    // Define all possible search results
    final List<Map<String, dynamic>> allResults = [
      {
        'title': 'Swahili Language Group',
        'subtitle': 'Community • 245 members',
        'type': 'Community'
      },
      {
        'title': 'Traditional East African Cuisine',
        'subtitle': 'Discussion • 89 posts',
        'type': 'Forum'
      },
      {
        'title': 'Ugandan Family History Resources',
        'subtitle': 'Cultural Resources • 12 items',
        'type': 'Resource'
      },
      {
        'title': 'Kenyan Cultural Festival 2024',
        'subtitle': 'Event • Next month',
        'type': 'Event'
      },
      {
        'title': 'African Oral History Project',
        'subtitle': 'Resource • 45 stories',
        'type': 'Resource'
      },
      {
        'title': 'Diaspora Mental Health Support',
        'subtitle': 'Community • 156 members',
        'type': 'Community'
      },
      {
        'title': 'Building Your Family Tree Workshop',
        'subtitle': 'Event • This weekend',
        'type': 'Event'
      },
    ];

    // Filter results based on search query
    return allResults.where((result) {
      final title = result['title']?.toString().toLowerCase() ?? '';
      final subtitle = result['subtitle']?.toString().toLowerCase() ?? '';
      final searchLower = _searchQuery.toLowerCase();

      return title.contains(searchLower) || subtitle.contains(searchLower);
    }).toList();
  }
}

class _SearchCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SearchCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $title...')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;

  const _SearchResultItem({
    required this.title,
    required this.subtitle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _getColorForType(type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getIconForType(type),
              color: _getColorForType(type), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening $title...')),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Community': return Icons.people;
      case 'Forum': return Icons.forum;
      case 'Resource': return Icons.library_books;
      case 'Event': return Icons.event;
      default: return Icons.search;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Community': return Colors.blue;
      case 'Forum': return Colors.green;
      case 'Resource': return Colors.orange;
      case 'Event': return Colors.purple;
      default: return Colors.grey;
    }
  }
}