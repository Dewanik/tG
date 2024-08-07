import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as l2;
import 'package:location/location.dart' as l1;
import 'package:t_guide/loggedIn/userPage.dart';
import 'TGMaps.dart';
import 'zipcode_finder.dart';
import 'LoginPage.dart'; // Import the login page
import 'package:geocoding/geocoding.dart' as geocoding; // Alias the geocoding packa ge
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:t_guide/loggedIn/Lsettings.dart';

Future<void> supaInit() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vyyklhaaerlokvoslcar.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5eWtsaGFhZXJsb2t2b3NsY2FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgwMjcwNjUsImV4cCI6MjAyMzYwMzA2NX0.p_81H973ZvrPBLVkTFJhWeim8RtovyP4ADSqExZEkkA',
  );
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return MaterialApp(
      theme: darkModeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
  final TextEditingController _controller2 = TextEditingController();
  String _output = '';
  final ZipcodeFinder _zipcodeFinder = ZipcodeFinder();
  final l1.Location _location = l1.Location();
  var latlong_current;
  String _searchtrm = '';



  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    bool _serviceEnabled;
    l1.PermissionStatus _permissionGranted;
    l1.LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == l1.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != l1.PermissionStatus.granted) {
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
       setState(()  {
     // ignore: await_only_futures
     latlong_current =  l2.LatLng(lat,lon);
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
                      flex: 4,
                      child: TGMaps(initial_loc: latlong_current,),
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
                            color: Color.fromARGB(100, 0, 0, 0),
                            child: Text(
                              _output,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // New section for trips/guides experiences
              SizedBox(height:20),
      Text(
'EXCLUSIVE LOCALITY TRAVEL EXPERIENCES IN $_searchtrm',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.white,
)),SizedBox(height:20),
              Expanded(
                child: PageView.builder(
                  
                  scrollDirection: Axis.vertical,
                  itemCount: _experiences.length,
                  itemBuilder: (context, index) {
                    return _buildExperiencePage(_experiences[index]);
                  },
                ),
              ),
                      
            ],
          ),
          Positioned(
            top: 40,
            right: 0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.account_circle_rounded, color: Colors.white, size: 30),
                  onPressed: () {
                    final supa_init = supaInit();
                    if (Supabase.instance.client.auth.currentSession != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage(
                            userData: UserData(
                              // name: 'John Doe', // Replace with actual user data
                              email: Supabase.instance.client.auth.currentUser?.email ?? 'unknown',
                            ),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _experiences = [
    {
      'title': 'Trip/Guide Experience 1',
      'description': 'Description of the trip or guide experience 1.',
      'mediaUrls': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
    {
      'title': 'Trip/Guide Experience 2',
      'description': 'Description of the trip or guide experience 2.',
      'mediaUrls': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
    {
      'title': 'Trip/Guide Experience 3',
      'description': 'Description of the trip or guide experience 3.',
      'mediaUrls': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
  ];

  Widget _buildExperiencePage(Map<String, dynamic> experience) {
    return Card(
      child: Container(
        width: double.infinity, // Ensure the card takes full width
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: experience['mediaUrls'].length,
                itemBuilder: (context, index) {
                  return Image.network(
                    experience['mediaUrls'][index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                experience['title'],
                overflow: TextOverflow.ellipsis, // Handle overflow of text
              ),
              subtitle: Text(
                experience['description'],
                overflow: TextOverflow.ellipsis, // Handle overflow of text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
