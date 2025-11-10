import 'package:flutter/material.dart';
import '../models/heritage_site.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/heritage_site_service.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final HeritageSiteService _heritageSiteService = HeritageSiteService();
  
  User? currentUser;
  List<HeritageSite> featuredSites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Load user data
    final user = await _authService.getCurrentUser();
    
    // Load heritage sites
    final sites = await _heritageSiteService.getHeritageSites();
    
    setState(() {
      currentUser = user;
      featuredSites = sites.take(3).toList(); // Get first 3 as featured
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Heritage')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = currentUser ?? User(
      id: '0',
      name: 'Guest',
      email: '',
      joinDate: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Heritage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue),
            onPressed: () => _openSearchScreen(context),
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.blue),
            onPressed: () => _showNotifications(),
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'G',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () => _showProfile(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Welcome Section
              _buildWelcomeSection(user),
              SizedBox(height: 24),

              // Quick Stats
              _buildQuickStats(),
              SizedBox(height: 24),

              // Featured Heritage Sites
              _buildFeaturedSites(),
              SizedBox(height: 24),

              // Cultural Insights
              _buildCulturalInsights(),
              SizedBox(height: 24),

              // Recent Activity
              _buildRecentActivity(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Widget _buildWelcomeSection(User user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.purple[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue,
            child: Text(
              currentUser.name[0],
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Karibu, ${user.name}! 👋',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                ),
                SizedBox(height: 4),
                Text(
                  user.culturalBackground != null 
                      ? 'Preserving ${user.culturalBackground} heritage'
                      : 'Preserving your heritage',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: user.languages.isNotEmpty 
                      ? user.languages.map((language) => Chip(
                    label: Text(
                      language,
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue[100],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList()
                      : [Chip(
                          label: Text('No languages set'),
                          backgroundColor: Colors.grey[200],
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 HERITAGE JOURNEY',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800]),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatCard(number: '12', label: 'Sites Visited', color: Colors.blue, icon: Icons.landscape),
            _StatCard(number: '5', label: 'Family Trees', color: Colors.green, icon: Icons.account_tree),
            _StatCard(number: '23', label: 'Memories', color: Colors.orange, icon: Icons.photo_library),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedSites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🗺️ FEATURED HERITAGE SITES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800]),
            ),
            TextButton(
              onPressed: () => _viewAllSites(),
              child: Text(
                'View All',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: featuredSites.map((site) => _HeritageSiteCard(site: site)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCulturalInsights() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[50]!, Colors.amber[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Cultural Insight of the Day',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange[800]),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'In many East African cultures, storytelling (Hadithi) is used to pass wisdom and history between generations. Elders gather children around the fire to share tales that teach moral lessons and preserve cultural heritage.',
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.4),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareStory(),
                  icon: Icon(Icons.share, size: 18),
                  label: Text('Share Your Story'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () => _saveInsight(),
                icon: Icon(Icons.bookmark_border, color: Colors.orange),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final List<Map<String, dynamic>> activities = [
      {
        'icon': Icons.family_restroom,
        'activity': 'Added grandfather to family tree',
        'time': '2 days ago',
        'color': Colors.green
      },
      {
        'icon': Icons.photo_library,
        'activity': 'Uploaded 5 heritage photos',
        'time': '1 week ago',
        'color': Colors.blue
      },
      {
        'icon': Icons.people,
        'activity': 'Connected with 3 relatives',
        'time': '2 weeks ago',
        'color': Colors.purple
      },
      {
        'icon': Icons.forum,
        'activity': 'Joined Swahili language forum',
        'time': '3 weeks ago',
        'color': Colors.orange
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📅 RECENT ACTIVITY',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800]),
        ),
        SizedBox(height: 12),
        ...activities.map((activity) => _ActivityItem(
          icon: activity['icon'] as IconData,
          activity: activity['activity'] as String,
          time: activity['time'] as String,
          color: activity['color'] as Color,
        )).toList(),
        SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => _viewAllActivity(),
            child: Text(
              'View All Activity',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void _openSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications feature coming soon!')),
    );
  }

  void _showProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile feature coming soon!')),
    );
  }

  void _viewAllSites() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing all heritage sites...')),
    );
  }

  void _shareStory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening story sharing...')),
    );
  }

  void _saveInsight() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Insight saved to your collection!')),
    );
  }

  void _viewAllActivity() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing all activity...')),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.number,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _HeritageSiteCard extends StatelessWidget {
  final HeritageSite site;

  const _HeritageSiteCard({required this.site});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.grey[300]!,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with gradient
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[100]!, Colors.blue[200]!],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Icon(Icons.landscape, size: 40, color: Colors.blue[600]),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  site.location,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Visit',
                    style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String activity;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.activity,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          activity,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}