import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'booked_trips.dart';

class ProfileApp extends StatefulWidget {
  @override
  _ProfileAppState createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final supbase = Supabase.instance.client;

  List<List<TextEditingController>> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = _pages.map((page) {
      return List.generate(page['fields'].length, (index) => TextEditingController());
    }).toList();
  }

  @override
  void dispose() {
    for (var controllers in _controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _saveProfile() async {
    try {
      final name = _controllers[0][0].text;
      final email = _controllers[0][1].text;
      final phone = _controllers[0][2].text;
      final address = _controllers[0][3].text;
      

      // Implement your logic to save/update the profile information
      print('Name: $name');
      print('Email: $email');
      print('Phone: $phone');
      print('Address: $address');
     

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile Updated Successfully!")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  List<Map<String, dynamic>> get _pages => [
    {
      'fields': [
     
        {'label': 'Email', 'type': TextInputType.emailAddress},
        {'label': 'Phone Number', 'type': TextInputType.phone},
     
      ],
    },
   
  ];

  Widget _buildProfilePage(List<Map<String, dynamic>> fields, int pageIndex) {
    return ProfilePageContent(fields: fields, controllers: _controllers[pageIndex]);
  }

  Widget _buildStepIndicator(int step) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: _currentPage >= step ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStepConnector() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Column(
        children: [
            _buildSectionHeader('Change Details'),
          // Steps marker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _pages.length; i++) ...[
                  _buildStepIndicator(i),
                  if (i < _pages.length - 1) _buildStepConnector(),
                ]
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                for (int i = 0; i < _pages.length; i++)
                  _buildProfilePage(_pages[i]['fields'], i)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Save'),
            ),
          ),
          _buildSectionHeader('Booked Trips'),
          Expanded(
            child: _buildBookedTripsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBookedTripsSection() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTripCard('Trip to Paris', '20th June 2024'),
        _buildTripCard('Trip to New York', '5th July 2024'),
        _buildTripCard('Trip to Tokyo', '15th August 2024'),
      ],
    );
  }

  Widget _buildTripCard(String tripTitle, String tripDate) {
    return Card(
      child: ListTile(
        title: Text(tripTitle),
        subtitle: Text(tripDate),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
           Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookedTrips()), // Navigate to the booked trips page
              );
          // Implement navigation to trip details
        },
      ),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final List<TextEditingController> controllers;

  const ProfilePageContent({Key? key, required this.fields, required this.controllers})
      : super(key: key);

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  late List<bool> _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = List.generate(widget.fields.length, (index) => widget.fields[index]['isPassword'] ?? false);
  }

  void _toggleVisibility(int index) {
    setState(() {
      _obscureText[index] = !_obscureText[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.fields.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: widget.controllers[i],
                decoration: InputDecoration(
                  labelText: widget.fields[i]['label'],
                  border: OutlineInputBorder(),
                  suffixIcon: widget.fields[i]['isPassword'] == true
                      ? IconButton(
                          icon: Icon(
                            _obscureText[i] ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => _toggleVisibility(i),
                        )
                      : null,
                ),
                keyboardType: widget.fields[i]['type'],
                obscureText: widget.fields[i]['isPassword'] == true ? _obscureText[i] : false,
              ),
            ),
        ],
      ),
    );
  }
}
