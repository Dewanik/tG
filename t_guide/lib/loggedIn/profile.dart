import 'package:flutter/material.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page Skeleton',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          _buildSectionHeader('Change Details'),
          _buildChangeDetailsSection(),
          _buildSectionHeader('Booked Trips'),
          _buildBookedTripsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Name',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'user@example.com',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
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

  Widget _buildChangeDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Implement save functionality
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookedTripsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTripCard('Trip to Paris', '20th June 2024'),
          _buildTripCard('Trip to New York', '5th July 2024'),
          _buildTripCard('Trip to Tokyo', '15th August 2024'),
        ],
      ),
    );
  }

  Widget _buildTripCard(String tripTitle, String tripDate) {
    return Card(
      child: ListTile(
        title: Text(tripTitle),
        subtitle: Text(tripDate),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Implement navigation to trip details
        },
      ),
    );
  }
}
