import 'package:flutter/material.dart';

class FamilyTreeScreen extends StatefulWidget {
  @override
  _FamilyTreeScreenState createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  String _searchQuery = '';
  int _selectedView = 0; // 0: Tree, 1: List, 2: Timeline

  final List<Map<String, dynamic>> _familyMembers = [
    {
      'id': '1',
      'name': 'Ahmed Jarudi',
      'birthYear': '1945',
      'deathYear': '2010',
      'relationship': 'Grandfather',
      'location': 'Kampala, Uganda',
      'stories': 5,
      'photos': 12,
      'generation': 2,
    },
    {
      'id': '2',
      'name': 'Fatima Jarudi',
      'birthYear': '1950',
      'relationship': 'Grandmother',
      'location': 'Kampala, Uganda',
      'stories': 8,
      'photos': 15,
      'generation': 2,
    },
    {
      'id': '3',
      'name': 'Hassan Jarudi',
      'birthYear': '1970',
      'relationship': 'Father',
      'location': 'Kampala, Uganda',
      'stories': 3,
      'photos': 20,
      'generation': 1,
    },
    {
      'id': '4',
      'name': 'Amina Jarudi',
      'birthYear': '1975',
      'relationship': 'Mother',
      'location': 'Kampala, Uganda',
      'stories': 6,
      'photos': 18,
      'generation': 1,
    },
    {
      'id': '5',
      'name': 'Hisham Jarudi',
      'birthYear': '2000',
      'relationship': 'You',
      'location': 'Kampala, Uganda',
      'stories': 2,
      'photos': 25,
      'generation': 0,
    },
    {
      'id': '6',
      'name': 'Yusuf Jarudi',
      'birthYear': '2005',
      'relationship': 'Brother',
      'location': 'Nairobi, Kenya',
      'stories': 1,
      'photos': 10,
      'generation': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Tree'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addFamilyMember,
          ),
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                _selectedView = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 0, child: Text('Tree View')),
              PopupMenuItem(value: 1, child: Text('List View')),
              PopupMenuItem(value: 2, child: Text('Timeline')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search family members...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // View Toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _ViewToggleButton(
                  label: 'Tree',
                  isSelected: _selectedView == 0,
                  onTap: () => setState(() => _selectedView = 0),
                ),
                _ViewToggleButton(
                  label: 'List',
                  isSelected: _selectedView == 1,
                  onTap: () => setState(() => _selectedView = 1),
                ),
                _ViewToggleButton(
                  label: 'Timeline',
                  isSelected: _selectedView == 2,
                  onTap: () => setState(() => _selectedView = 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Content based on selected view
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFamilyMember,
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedView) {
      case 0:
        return _buildTreeView();
      case 1:
        return _buildListView();
      case 2:
        return _buildTimelineView();
      default:
        return _buildTreeView();
    }
  }

  Widget _buildTreeView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Generation 2 (Grandparents)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _familyMembers
                .where((member) => member['generation'] == 2)
                .map((member) => _FamilyMemberNode(member: member))
                .toList(),
          ),
          SizedBox(height: 40),

          // Connector lines
          Container(
            height: 40,
            child: CustomPaint(
              painter: _TreeConnectorPainter(),
            ),
          ),

          // Generation 1 (Parents)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _familyMembers
                .where((member) => member['generation'] == 1)
                .map((member) => _FamilyMemberNode(member: member))
                .toList(),
          ),
          SizedBox(height: 40),

          // Connector lines
          Container(
            height: 40,
            child: CustomPaint(
              painter: _TreeConnectorPainter(),
            ),
          ),

          // Generation 0 (Current)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _familyMembers
                .where((member) => member['generation'] == 0)
                .map((member) => _FamilyMemberNode(member: member))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final filteredMembers = _familyMembers.where((member) {
      final name = member['name'].toString().toLowerCase();
      final relationship = member['relationship'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          relationship.contains(_searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return _FamilyMemberCard(member: member);
      },
    );
  }

  Widget _buildTimelineView() {
    // Sort by birth year for timeline
    final sortedMembers = List.from(_familyMembers);
    sortedMembers.sort((a, b) => a['birthYear'].compareTo(b['birthYear']));

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sortedMembers.length,
      itemBuilder: (context, index) {
        final member = sortedMembers[index];
        return _TimelineItem(member: member, isLast: index == sortedMembers.length - 1);
      },
    );
  }

  void _addFamilyMember() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddFamilyMemberSheet(),
    );
  }

  void _viewFullProfile(BuildContext context, Map<String, dynamic> member) {
    Navigator.pop(context); // Close the dialog first
    // Navigate to full profile page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening full profile for ${member['name']}...')),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class _FamilyMemberNode extends StatelessWidget {
  final Map<String, dynamic> member;

  const _FamilyMemberNode({required this.member});

  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relationship: ${member['relationship']}'),
            Text('Born: ${member['birthYear']}'),
            if (member['deathYear'] != null) Text('Died: ${member['deathYear']}'),
            Text('Location: ${member['location']}'),
            SizedBox(height: 16),
            Row(
              children: [
                _DetailChip(icon: Icons.photo_library, label: '${member['photos']} photos'),
                _DetailChip(icon: Icons.history_edu, label: '${member['stories']} stories'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => _viewFullProfile(context, member),
            child: Text('View Full Profile'),
          ),
        ],
      ),
    );
  }

  void _viewFullProfile(BuildContext context, Map<String, dynamic> member) {
    Navigator.pop(context); // Close the dialog first
    // Navigate to full profile page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening full profile for ${member['name']}...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMemberDetails(context, member),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 30, color: Colors.blue),
                Text(
                  member['relationship'].toString().split(' ').first,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            member['name'],
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          Text(
            '${member['birthYear']}${member['deathYear'] != null ? '-${member['deathYear']}' : ''}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  final Map<String, dynamic> member;

  const _FamilyMemberCard({required this.member});

  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relationship: ${member['relationship']}'),
            Text('Born: ${member['birthYear']}'),
            if (member['deathYear'] != null) Text('Died: ${member['deathYear']}'),
            Text('Location: ${member['location']}'),
            SizedBox(height: 16),
            Row(
              children: [
                _DetailChip(icon: Icons.photo_library, label: '${member['photos']} photos'),
                _DetailChip(icon: Icons.history_edu, label: '${member['stories']} stories'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => _viewFullProfile(context, member),
            child: Text('View Full Profile'),
          ),
        ],
      ),
    );
  }

  void _viewFullProfile(BuildContext context, Map<String, dynamic> member) {
    Navigator.pop(context); // Close the dialog first
    // Navigate to full profile page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening full profile for ${member['name']}...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          member['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${member['relationship']} • ${member['location']}'),
            Row(
              children: [
                Icon(Icons.cake, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Born ${member['birthYear']}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SmallChip(icon: Icons.photo_library, count: member['photos']),
            SizedBox(width: 4),
            _SmallChip(icon: Icons.history_edu, count: member['stories']),
          ],
        ),
        onTap: () => _showMemberDetails(context, member),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isLast;

  const _TimelineItem({required this.member, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line
        Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: Colors.blue,
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.blue,
              ),
          ],
        ),
        SizedBox(width: 16),

        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['birthYear'],
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  member['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  member['relationship'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 14),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(fontSize: 12),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final IconData icon;
  final dynamic count;

  const _SmallChip({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          SizedBox(width: 2),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 10, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class _TreeConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;

    // Draw horizontal connector
    canvas.drawLine(
      Offset(centerX - 100, size.height / 2),
      Offset(centerX + 100, size.height / 2),
      paint,
    );

    // Draw vertical connectors
    canvas.drawLine(
      Offset(centerX - 100, 0),
      Offset(centerX - 100, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + 100, 0),
      Offset(centerX + 100, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AddFamilyMemberSheet extends StatefulWidget {
  @override
  __AddFamilyMemberSheetState createState() => __AddFamilyMemberSheetState();
}

class __AddFamilyMemberSheetState extends State<_AddFamilyMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthYearController = TextEditingController();
  String _selectedRelationship = 'Parent';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Family Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _birthYearController,
              decoration: InputDecoration(
                labelText: 'Birth Year',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField(
              value: _selectedRelationship,
              items: [
                'Grandparent',
                'Parent',
                'Sibling',
                'Child',
                'Aunt/Uncle',
                'Cousin',
                'Spouse',
              ].map((relationship) {
                return DropdownMenuItem(
                  value: relationship,
                  child: Text(relationship),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Relationship',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveFamilyMember,
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _saveFamilyMember() {
    if (_formKey.currentState!.validate()) {
      // Save logic here
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Family member added!')),
      );
    }
  }
}