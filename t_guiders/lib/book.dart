import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final _searchController = TextEditingController();
  List<String> _currentTrips = ['Trip to New York', 'Trip to San Francisco'];
  List<String> _pastTrips = ['Trip to Los Angeles', 'Trip to Chicago'];
  List<String> _searchResults = [];

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _searchResults = [
        ..._currentTrips.where((trip) => trip.toLowerCase().contains(query)),
        ..._pastTrips.where((trip) => trip.toLowerCase().contains(query)),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Trips'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or Book ID',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: <Widget>[
                  if (_searchResults.isNotEmpty)
                    ..._searchResults.map((result) => ListTile(title: Text(result))),
                  if (_searchResults.isEmpty) ...[
                    Text(
                      'Current Trips',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._currentTrips.map((trip) => ListTile(title: Text(trip))),
                    SizedBox(height: 20.0),
                    Text(
                      'Past Trips',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._pastTrips.map((trip) => ListTile(title: Text(trip))),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
