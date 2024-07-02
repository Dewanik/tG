import 'package:flutter/material.dart';
import 'package:t_guide/loggedIn/guide.dart';

class BookedTrips extends StatelessWidget {
  final Map<String, dynamic> trip = {
    'title': 'Trip to Paris',
    'date': '20th June 2024',
    'images': [
      'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg',
      'https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8bmF0dXJhbHxlbnwwfHx8fDE3MTg1MDY5MDJ8MA&ixlib=rb-4.0.3'
    ],
    'details': 'A wonderful trip to Paris with all the amazing places to visit.',
    'package': 'Premium',
    'guide': {
      'name': 'John Doe',
      'photo': 'https://images.unsplash.com/photo-1594745564259-8e426b9c0b0e',
      'rating': 4.5,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Trip Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0,
                child: PageView.builder(
                  itemCount: trip['images'].length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      trip['images'][index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                trip['title'],
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Date: ${trip['date']}',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              Text(
                trip['details'],
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Package: ${trip['package']}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(trip['guide']['photo']),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['guide']['name'],
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4.0),
                          Text(
                            '${trip['guide']['rating']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Navigate to guide details page (implement this later)
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GuidePage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
