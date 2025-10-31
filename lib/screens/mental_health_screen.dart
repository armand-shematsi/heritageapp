import 'package:flutter/material.dart';

class MentalHealthScreen extends StatefulWidget {
  @override
  _MentalHealthScreenState createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  int _moodRating = 5;
  String _moodNotes = '';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _moodHistory = [
    {'date': 'Today', 'mood': 7, 'notes': 'Feeling connected to community'},
    {'date': 'Yesterday', 'mood': 4, 'notes': 'Missing home today'},
    {'date': 'Nov 10', 'mood': 8, 'notes': 'Great cultural event!'},
    {'date': 'Nov 9', 'mood': 6, 'notes': 'Talked with family back home'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Wellness'),
        actions: [
          IconButton(
            icon: Icon(Icons.insights),
            onPressed: _showAnalytics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Tracking Card
            _buildMoodTracker(),
            SizedBox(height: 20),

            // AI Wellness Insights
            _buildAIInsights(),
            SizedBox(height: 20),

            // Mood History
            _buildMoodHistory(),
            SizedBox(height: 20),

            // Support Resources
            _buildSupportResources(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTracker() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mood, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Mood Rating
            Text('Mood Rating: $_moodRating/10',
                style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Slider(
              value: _moodRating.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _moodRating = value.round();
                });
              },
              activeColor: _getMoodColor(_moodRating),
            ),
            SizedBox(height: 16),

            // Mood Notes
            Text('Add notes about your day:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'How was your day? Any cultural connections?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => _moodNotes = value,
            ),
            SizedBox(height: 16),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveMoodEntry,
              icon: Icon(Icons.save),
              label: Text('Save Mood Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'AI Wellness Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Based on your mood patterns, we suggest connecting with community members who share similar cultural backgrounds. Engaging in cultural activities can help reduce feelings of homesickness.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InsightChip(label: 'Connect with peers', icon: Icons.people),
                _InsightChip(label: 'Join cultural event', icon: Icons.event),
                _InsightChip(label: 'Share your story', icon: Icons.history_edu),
                _InsightChip(label: 'Practice language', icon: Icons.language),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ..._moodHistory.map((entry) => _MoodHistoryItem(
              date: entry['date'] as String,
              mood: entry['mood'] as int,
              notes: entry['notes'] as String,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportResources() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Resources',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _SupportResource(
              title: '24/7 Crisis Helpline',
              description: 'Multilingual support available',
              icon: Icons.phone,
              color: Colors.red,
              onTap: () => _callHelpline(),
            ),
            _SupportResource(
              title: 'Peer Support Groups',
              description: 'Connect with others in diaspora',
              icon: Icons.group,
              color: Colors.green,
              onTap: () => _joinSupportGroup(),
            ),
            _SupportResource(
              title: 'Cultural Counselors',
              description: 'Culturally-aware professionals',
              icon: Icons.medical_services,
              color: Colors.blue,
              onTap: () => _findCounselor(),
            ),
            _SupportResource(
              title: 'Emergency Resources',
              description: 'Immediate help and guidance',
              icon: Icons.emergency,
              color: Colors.orange,
              onTap: () => _showEmergencyResources(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int rating) {
    if (rating <= 3) return Colors.red;
    if (rating <= 6) return Colors.orange;
    return Colors.green;
  }

  void _saveMoodEntry() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood entry saved!')),
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Showing mood analytics...')),
    );
  }

  void _callHelpline() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connecting to helpline...')),
    );
  }

  void _joinSupportGroup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Finding support groups...')),
    );
  }

  void _findCounselor() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for cultural counselors...')),
    );
  }

  void _showEmergencyResources() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Showing emergency resources...')),
    );
  }
}

class _InsightChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InsightChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      backgroundColor: Colors.purple[50],
      labelStyle: TextStyle(fontSize: 12),
    );
  }
}

class _MoodHistoryItem extends StatelessWidget {
  final String date;
  final int mood;
  final String notes;

  const _MoodHistoryItem({
    required this.date,
    required this.mood,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getMoodColor(mood).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getMoodIcon(mood),
              color: _getMoodColor(mood),
              size: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  notes,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$mood/10',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getMoodColor(mood),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(int rating) {
    if (rating <= 3) return Colors.red;
    if (rating <= 6) return Colors.orange;
    return Colors.green;
  }

  IconData _getMoodIcon(int rating) {
    if (rating <= 3) return Icons.sentiment_very_dissatisfied;
    if (rating <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_very_satisfied;
  }
}

class _SupportResource extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SupportResource({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(description, style: TextStyle(fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 4),
    );
  }
}