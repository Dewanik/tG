import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  double initialRating = 4.5;
  double userRating = 0.0;
  TextEditingController feedbackController = TextEditingController();
  int _currentPage = 0;

  final List<Map<String, String>> imageList = [
    {"imagePath": "assets/image1.jpg", "caption": "Beautiful Sunset"},
    {"imagePath": "assets/image2.jpg", "caption": "Mountain Hike"},
    {"imagePath": "assets/image3.jpg", "caption": "City Tour"},
  ];

  void _submitFeedback() {
    // Handle feedback submission
    setState(() {
      feedbackController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo and Caption Section
            Container(
              height: 200.0,
              child: PageView.builder(
                itemCount: imageList.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(imageList[index]['imagePath']!, fit: BoxFit.cover),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            imageList[index]['caption']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.map((url) {
                int index = imageList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            // Rating Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rating: $initialRating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Text(
                      initialRating.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // User Rating Section
            Row(
              children: [
                Text(
                  'Your Rating: ',
                  style: TextStyle(fontSize: 16),
                ),
                RatingBar.builder(
                  initialRating: userRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      userRating = rating;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Feedback Section
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                labelText: 'Leave your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
            SizedBox(height: 32.0),
            // About Guide Section
            Text(
              'About Guide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Guide Name: John Doe\nExperience: 10 years in the tourism industry.\nSpecialization: Historical tours and cultural experiences.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32.0),
            // Experiences Offered Section
            Text(
              'Experiences Offered',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Historical City Tours'),
                    subtitle: Text('Explore the rich history of the city with our guided tours.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Cultural Immersion Programs'),
                    subtitle: Text('Immerse yourself in the local culture with our tailored programs.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Adventure Hikes'),
                    subtitle: Text('Join us for thrilling hikes in beautiful landscapes.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Culinary Tours'),
                    subtitle: Text('Experience the local cuisine with our guided culinary tours.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Customized Itineraries'),
                    subtitle: Text('Get a personalized tour experience with our custom itineraries.'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
