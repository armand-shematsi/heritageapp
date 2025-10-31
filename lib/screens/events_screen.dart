import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedCategory = 0; // 0: All, 1: Virtual, 2: In-Person
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _eventCategories = [
    {'name': 'All', 'icon': Icons.all_inclusive},
    {'name': 'Virtual', 'icon': Icons.videocam},
    {'name': 'In-Person', 'icon': Icons.location_on},
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Traditional Dance Festival',
      'date': '2024-11-15',
      'time': '18:00',
      'location': 'Virtual Event',
      'description': 'Learn traditional dances from various African cultures with expert instructors',
      'type': 'Virtual',
      'price': 'Free',
      'attendees': 45,
      'image': 'dance',
      'host': 'African Cultural Center',
      'duration': '2 hours',
    },
    {
      'id': '2',
      'title': 'Swahili Language Exchange',
      'date': '2024-11-20',
      'time': '16:00',
      'location': 'Community Center, Kampala',
      'description': 'Practice Swahili with native speakers and learners',
      'type': 'In-Person',
      'price': 'Free',
      'attendees': 23,
      'image': 'language',
      'host': 'Swahili Learners Group',
      'duration': '1.5 hours',
    },
    {
      'id': '3',
      'title': 'East African Cooking Workshop',
      'date': '2024-11-25',
      'time': '14:00',
      'location': 'Virtual Event',
      'description': 'Cook traditional East African dishes with Chef Amina',
      'type': 'Virtual',
      'price': '\$15',
      'attendees': 32,
      'image': 'cooking',
      'host': 'Chef Amina Hassan',
      'duration': '2.5 hours',
    },
    {
      'id': '4',
      'title': 'Cultural Storytelling Night',
      'date': '2024-12-01',
      'time': '19:00',
      'location': 'Heritage Museum, Nairobi',
      'description': 'Share and listen to cultural stories from elders',
      'type': 'In-Person',
      'price': '\$5',
      'attendees': 18,
      'image': 'storytelling',
      'host': 'Elders Council',
      'duration': '3 hours',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cultural Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _openCalendar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _eventCategories.length,
              itemBuilder: (context, index) {
                final category = _eventCategories[index];
                return _EventCategoryChip(
                  name: category['name'] as String,
                  icon: category['icon'] as IconData,
                  isSelected: _selectedCategory == index,
                  onTap: () => setState(() => _selectedCategory = index),
                );
              },
            ),
          ),

          // Date Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getFormattedDate(_selectedDate),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _previousDay,
                    ),
                    Text('Today'),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _nextDay,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Events List
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEvent,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventsList() {
    final filteredEvents = _events.where((event) {
      if (_selectedCategory == 0) return true;
      if (_selectedCategory == 1) return event['type'] == 'Virtual';
      if (_selectedCategory == 2) return event['type'] == 'In-Person';
      return true;
    }).toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No events found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try different filters or dates',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return _EventCard(event: event);
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  void _openCalendar() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        setState(() {
          _selectedDate = date;
        });
      }
    });
  }

  void _createEvent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CreateEventSheet(),
    );
  }
}

class _EventCategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _EventCategoryChip({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(name),
        avatar: Icon(icon, size: 16),
        selected: isSelected,
        onSelected: (selected) => onTap(),
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  void _shareEvent(BuildContext context, Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${event['title']}...')),
    );
  }

  void _registerForEvent(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register for Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['title'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Date: ${event['date']} at ${event['time']}'),
            Text('Location: ${event['location']}'),
            SizedBox(height: 16),
            Text('Price: ${event['price']}'),
            SizedBox(height: 8),
            Text(
              'You will receive a confirmation email with event details and joining instructions.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully registered for ${event['title']}!')),
              );
            },
            child: Text('Confirm Registration'),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String imageType) {
    switch (imageType) {
      case 'dance': return Colors.purple;
      case 'language': return Colors.blue;
      case 'cooking': return Colors.orange;
      case 'storytelling': return Colors.green;
      default: return Colors.blue;
    }
  }

  IconData _getEventIcon(String imageType) {
    switch (imageType) {
      case 'dance': return Icons.celebration;
      case 'language': return Icons.language;
      case 'cooking': return Icons.restaurant;
      case 'storytelling': return Icons.history_edu;
      default: return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image/Color
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: _getEventColor(event['image'] as String),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                _getEventIcon(event['image'] as String),
                size: 40,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: event['type'] == 'Virtual'
                            ? Colors.blue[50]
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event['type'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: event['type'] == 'Virtual'
                              ? Colors.blue[700]
                              : Colors.green[700],
                        ),
                      ),
                    ),
                    Text(
                      event['price'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Event Title
                Text(
                  event['title'] as String,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Event Details
                _EventDetailRow(
                  icon: Icons.calendar_today,
                  text: '${event['date']} • ${event['time']}',
                ),
                _EventDetailRow(
                  icon: Icons.location_on,
                  text: event['location'] as String,
                ),
                _EventDetailRow(
                  icon: Icons.person,
                  text: 'Hosted by ${event['host']}',
                ),
                _EventDetailRow(
                  icon: Icons.timer,
                  text: 'Duration: ${event['duration']}',
                ),
                SizedBox(height: 8),

                // Description
                Text(
                  event['description'] as String,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),

                // Attendees and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          '${event['attendees']} attending',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => _shareEvent(context, event),
                          child: Text('Share'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _registerForEvent(context, event),
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventDetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class _CreateEventSheet extends StatefulWidget {
  @override
  __CreateEventSheetState createState() => __CreateEventSheetState();
}

class __CreateEventSheetState extends State<_CreateEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedType = 'Virtual';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
              'Create New Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField(
              value: _selectedType,
              items: ['Virtual', 'In-Person'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Event Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: _selectedType == 'Virtual' ? 'Platform/URL' : 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectDate,
                    child: Text('Select Date'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectTime,
                    child: Text('Select Time'),
                  ),
                ),
              ],
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
                    onPressed: _createEvent,
                    child: Text('Create Event'),
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

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );
    }
  }
}