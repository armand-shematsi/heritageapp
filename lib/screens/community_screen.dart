import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedLanguage = 'english';
  int _selectedForumIndex = 0;

  final List<Map<String, dynamic>> _forums = [
    {
      'icon': Icons.language,
      'title': 'Language Learning',
      'description': 'Practice and learn native languages',
      'members': '1.2k',
      'recentPosts': 23,
      'color': Colors.blue,
    },
    {
      'icon': Icons.celebration,
      'title': 'Cultural Festivals',
      'description': 'Share and discuss traditional celebrations',
      'members': '856',
      'recentPosts': 15,
      'color': Colors.green,
    },
    {
      'icon': Icons.emoji_food_beverage,
      'title': 'Traditional Cuisine',
      'description': 'Recipes and cooking techniques',
      'members': '2.1k',
      'recentPosts': 45,
      'color': Colors.orange,
    },
    {
      'icon': Icons.history_edu,
      'title': 'Oral History',
      'description': 'Share family stories and traditions',
      'members': '543',
      'recentPosts': 12,
      'color': Colors.purple,
    },
    {
      'icon': Icons.music_note,
      'title': 'Traditional Music',
      'description': 'Cultural music and instruments',
      'members': '432',
      'recentPosts': 8,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Forum'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchForums,
          ),
        ],
      ),
      body: Column(
        children: [
          // Language Selection
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  icon: Icon(Icons.translate, color: Colors.blue),
                  items: [
                    _buildLanguageItem('english', 'English', '🇺🇸'),
                    _buildLanguageItem('spanish', 'Spanish', '🇪🇸'),
                    _buildLanguageItem('french', 'French', '🇫🇷'),
                    _buildLanguageItem('arabic', 'Arabic', '🇸🇦'),
                    _buildLanguageItem('swahili', 'Swahili', '🇹🇿'),
                    _buildLanguageItem('amharic', 'Amharic', '🇪🇹'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
              ),
            ),
          ),

          // Active Forums Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Forums',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_forums.length} communities',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          // Forum List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _forums.length,
              itemBuilder: (context, index) {
                final forum = _forums[index];
                return _ForumCategory(
                  icon: forum['icon'] as IconData,
                  title: forum['title'] as String,
                  description: forum['description'] as String,
                  members: forum['members'] as String,
                  recentPosts: forum['recentPosts'] as int,
                  color: forum['color'] as Color,
                  isActive: index == _selectedForumIndex,
                  onTap: () {
                    setState(() {
                      _selectedForumIndex = index;
                    });
                    _openForumChat(forum);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }

  DropdownMenuItem<String> _buildLanguageItem(String value, String text, String flag) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Text(flag, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _searchForums() {
    // Implement forum search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Search forums...')),
    );
  }

  void _openForumChat(Map<String, dynamic> forum) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForumChatScreen(forum: forum),
      ),
    );
  }

  void _createNewPost() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Create new post...')),
    );
  }
}

class _ForumCategory extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String members;
  final int recentPosts;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ForumCategory({
    required this.icon,
    required this.title,
    required this.description,
    required this.members,
    required this.recentPosts,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: isActive ? 4 : 1,
      color: isActive ? color.withOpacity(0.05) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive ? color.withOpacity(0.3) : Colors.transparent,
          width: isActive ? 2 : 0,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? color : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(description),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people_outline, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(members, style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('$recentPosts new', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isActive ? color : Colors.grey,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// Forum Chat Screen
class ForumChatScreen extends StatefulWidget {
  final Map<String, dynamic> forum;

  const ForumChatScreen({required this.forum});

  @override
  _ForumChatScreenState createState() => _ForumChatScreenState();
}

class _ForumChatScreenState extends State<ForumChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'user': 'Amina Hassan',
      'message': 'Does anyone have traditional Swahili recipes?',
      'time': '2 hours ago',
      'isMe': false,
      'avatar': 'AH',
    },
    {
      'id': '2',
      'user': 'You',
      'message': 'I have my grandmother\'s recipe for biryani!',
      'time': '1 hour ago',
      'isMe': true,
      'avatar': 'ME',
    },
    {
      'id': '3',
      'user': 'Jabari Okoro',
      'message': 'We should organize a virtual cooking session!',
      'time': '45 mins ago',
      'isMe': false,
      'avatar': 'JO',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.forum['title'] as String),
            Text(
              '${widget.forum['members']} members',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _viewMembers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Forum Info Banner
          Container(
            padding: EdgeInsets.all(16),
            color: (widget.forum['color'] as Color).withOpacity(0.1),
            child: Row(
              children: [
                Icon(widget.forum['icon'] as IconData,
                    color: widget.forum['color'] as Color),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.forum['description'] as String,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return _ChatMessage(
                  user: message['user'] as String,
                  message: message['message'] as String,
                  time: message['time'] as String,
                  isMe: message['isMe'] as bool,
                  avatar: message['avatar'] as String,
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().toString(),
        'user': 'You',
        'message': _messageController.text,
        'time': 'Just now',
        'isMe': true,
        'avatar': 'ME',
      });
    });

    _messageController.clear();
  }

  void _viewMembers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Community Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MemberItem(name: 'Amina Hassan', role: 'Active Member'),
            _MemberItem(name: 'Jabari Okoro', role: 'Community Elder'),
            _MemberItem(name: 'Fatima Diallo', role: 'Language Expert'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final String user;
  final String message;
  final String time;
  final bool isMe;
  final String avatar;

  const _ChatMessage({
    required this.user,
    required this.message,
    required this.time,
    required this.isMe,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMe
            ? _buildMyMessage()
            : _buildOtherMessage(),
      ),
    );
  }

  List<Widget> _buildMyMessage() {
    return [
      Flexible(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message, style: TextStyle(fontSize: 14)),
              SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
      SizedBox(width: 8),
      CircleAvatar(
        radius: 16,
        backgroundColor: Colors.blue,
        child: Text(
          avatar,
          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  List<Widget> _buildOtherMessage() {
    return [
      CircleAvatar(
        radius: 16,
        backgroundColor: Colors.green,
        child: Text(
          avatar,
          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(width: 8),
      Flexible(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 4),
              Text(message, style: TextStyle(fontSize: 14)),
              SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    ];
  }
}

class _MemberItem extends StatelessWidget {
  final String name;
  final String role;

  const _MemberItem({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          name.split(' ').map((n) => n[0]).join(),
          style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role, style: TextStyle(fontSize: 12)),
      trailing: Icon(Icons.chat, size: 20, color: Colors.blue),
    );
  }
}