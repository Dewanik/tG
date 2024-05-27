import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'TGMaps.dart';
import 'zipcode_finder.dart';
import 'LoginPage.dart'; // Import the login page
import 'package:geocoding/geocoding.dart' as geocoding; // Alias the geocoding package

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent the resize when the keyboard is opened
        body: MyHome(),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  final PageController _controller = PageController();
  TextEditingController _controller2 = TextEditingController();
  String _output = '';
  final ZipcodeFinder _zipcodeFinder = ZipcodeFinder();
  final Location _location = Location();
   String _searchtrm = '';
  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
    // TODO : use this setState to update search_term when search_term not available and using current location
    /*setState(() {
     _searchtrm = (geocoding.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude)).;
    });*/
    _fetchZipCodes(_locationData.latitude!, _locationData.longitude!);
  }

  Future<void> _fetchZipCodes(double lat, double lon) async {
    try {
      var radius = 1.60934; // Start with 1 mile in kilometers
      const double maxRadius = 16.0934; // 10 miles in kilometers
      Set<String> zipCodes = await _zipcodeFinder.findDifferentZipCodes(lat, lon, radius);

      while (zipCodes.length < 3 && radius <= maxRadius) { // Ensure radius does not exceed 10 miles
        radius += 1.60934; // Increase by 1 mile
        zipCodes = await _zipcodeFinder.findDifferentZipCodes(lat, lon, radius);
      }

      var output = 'Location: ($lat, $lon)\n'
          'Radius used: ${radius / 1.60934} miles\n'
          'Zip Codes: ${zipCodes.join(", ")}';

      setState(() {
        _output = output;
      });
      print(output);
    } catch (e, stacktrace) {
      setState(() {
        _output = 'Error occurred: $e';
      });
      print('Error: $e\nStacktrace: $stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: [
                    Image.network(
                      'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://buffer.com/library/content/images/2023/10/free-images.jpg',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
              // Maps Based Experiences Search
              Expanded(
                child: Stack(
                  children: [
                    Expanded(
                      flex:4,
                      child:TGMaps()
                    ),
                   
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller2,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Search',
                              hintText: 'Enter search term',
                              prefixIcon: Icon(Icons.search, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                borderSide: BorderSide(color: Colors.blue, width: 10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                borderSide: BorderSide(color: Colors.green, width: 2.0),
                              ),
                              labelStyle: TextStyle(color: Colors.blue),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.black),
                            onSubmitted: (value) async {
                              if (value.isEmpty) {
                                _fetchCurrentLocation();
                              }
                              try {
                                setState(() {
                                  _searchtrm = value.toUpperCase();
                                });
                                print('Searching for: $value');
                                List<geocoding.Location>? locations = await _zipcodeFinder.locationFromAddressSafe(value);
                                print('Search results: $locations');
                                if (locations == null || locations.isEmpty) {
                                  setState(() {
                                    _output = 'No results found';
                                  });
                                  print('No results found');
                                  return;
                                }
                                geocoding.Location location = locations[0];
                                var lat = location.latitude;
                                var lon = location.longitude;
                                var radius = 1.60934; // Start with 1 mile in kilometers
                                const double maxRadius = 16.0934; // 10 miles in kilometers
                                Set<String> zipCodes = await _zipcodeFinder.findDifferentZipCodes(lat, lon, radius);

                                while (zipCodes.length < 3 && radius <= maxRadius) { // Ensure radius does not exceed 10 miles
                                  radius += 1.60934; // Increase by 1 mile
                                  zipCodes = await _zipcodeFinder.findDifferentZipCodes(lat, lon, radius);
                                }

                                var output = 'Location: ($lat, $lon)\n'
                                    'Radius used: ${radius / 1.60934} miles\n'
                                    'Zip Codes: ${zipCodes.join(", ")}';

                                setState(() {
                                  _output = output;
                                });
                                print(output);
                              } catch (e, stacktrace) {
                                setState(() {
                                  _output = 'Error occurred: $e';
                                });
                                print('Error: $e\nStacktrace: $stacktrace');
                              }
                            },
                          ),
                          SizedBox(height: 16),
                          Container(
                          color:Color.fromARGB(100, 0, 0, 0),
                          child:Text(
                            _output,
                            style: TextStyle(color: Colors.white),
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // New section for trips/guides experiences
Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'EXCLUSIVE LOCALITY TRAVEL EXPERIENCES IN $_searchtrm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      Expanded(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16.0),
          children: [
            // Skeleton for horizontal cards
            Card(
              child: Container(
                width: 200, // Set a fixed width for the cards
                child: ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Trip/Guide Experience 1'),
                  subtitle: Text('Description of the trip or guide experience.'),
                ),
              ),
            ),
            Card(
              child: Container(
                width: 200, // Set a fixed width for the cards
                child: ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Trip/Guide Experience 2'),
                  subtitle: Text('Description of the trip or guide experience.'),
                ),
              ),
            ),
            Card(
              child: Container(
                width: 200, // Set a fixed width for the cards
                child: ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Trip/Guide Experience 3'),
                  subtitle: Text('Description of the trip or guide experience.'),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)


            ],
          ),
          Positioned(
            top: 40,
            right: 0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.login, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
