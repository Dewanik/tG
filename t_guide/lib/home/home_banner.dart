import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TGMaps.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'dart:async';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Stack(
          children: [
            SizedBox(
              height: 500,
              child: TGMaps(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
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
                    setState(() {
                      _output = 'Please enter a search term';
                    });
                    return;
                  }
                  try {
                    print('Searching for: $value');
                    List<Location>? locations = await _locationFromAddressSafe(value);
                    print('Search results: $locations');
                    if (locations == null || locations.isEmpty) {
                      setState(() {
                        _output = 'No results found';
                      });
                      print('No results found');
                      return;
                    }
                    var output = locations[0].toString();
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
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _output,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<List<Location>?> _locationFromAddressSafe(String address) async {
    return await GeocodingPlatform.instance?.locationFromAddress(address);
  }
}
