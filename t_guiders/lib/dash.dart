import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'db.dart';
import 'book.dart';
import 'login.dart';
import 'manageT.dart';
import 'pay.dart';
import 'profile.dart';
import 'trips_d.dart';

class MyDashPage extends StatefulWidget {
  const MyDashPage({Key? key}) : super(key: key);

  @override
  State<MyDashPage> createState() => _MyDashPageState();
}

class _MyDashPageState extends State<MyDashPage> {
  String dropValue = '';
  List<String> categories = [];
  List<String> experienceNames = [];
  final user_id = Supabase.instance.client.auth.currentUser?.id;
  var supabaseClient = SupabaseC();

  @override
  void initState() {
    super.initState();
    if (Supabase.instance.client.auth.currentSession == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage(context)));
    }
    getNames();
    getCategory();
    void handleInserts(payload) {
      getCategory();
      getNames();
      print(payload);
    }

    final supabaseCC = Supabase.instance.client;
    supabaseCC
        .channel("guide_trips")
        .onPostgresChanges(
            table: "guide_trips",
            event: PostgresChangeEvent.all,
            callback: handleInserts)
        .subscribe();
  }

  Future<List> getTripDetails({required String value}) async {
    var tripstemp = [];
    var data = await supabaseClient.getData("guide_trips", "user", user_id);
    for (var item in data) {
      var each_d = item['trip_details'];
      if (each_d is Map<String, dynamic>) {
        Map<String, dynamic> tripDetails = each_d;
        if (tripDetails['name'] == value) {
          tripstemp.add(tripDetails);
        }
      }
    }
    return tripstemp;
  }

  Future<void> getNames({String s_category = 'default'}) async {
    var data = await supabaseClient.getData("guide_trips", "user", user_id);
    Set<String> tempName = {};
    for (var item in data) {
      var each_d = item['trip_details'];
      if (s_category != "default") {
        if ((each_d['category'] == s_category) || (s_category == "Not Available")) {
          tempName.add(each_d['name'] ?? "Not Available");
        }
      } else {
        tempName.add(each_d['name'] ?? "Not Available");
      }
    }
    setState(() {
      experienceNames = tempName.toList();
    });
  }

  Future<void> getCategory() async {
    var data = await supabaseClient.getData("guide_trips", "user", user_id);
    Set<String> tempCategories = {};
    for (var item in data) {
      var each_d = item['trip_details'];
      tempCategories.add(each_d['category'] ?? "Not Available");
    }
    setState(() {
      categories = tempCategories.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dash Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Pay Methods'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentMethodPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Booked Trips'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Manage Trips'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageTripsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Supabase.instance.client.auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage(context)));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi User,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'According to your given address:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(),
            const SizedBox(height: 20),
            const Text(
              "You're serving zip codes:",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'a, b, c1, d',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your experiences under category:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: dropValue.isEmpty ? null : dropValue,
              items: categories.map((String value1) {
                return DropdownMenuItem<String>(
                  value: value1,
                  child: Text(value1),
                );
              }).toList(),
              onChanged: (value) {
                getNames(s_category: value!);
                setState(() {
                  dropValue = value!;
                });
              },
              hint: Text(dropValue.isEmpty ? 'Select a category' : dropValue),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: experienceNames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(7.0),
                        color: Colors.grey[300],
                        child: Center(child: Text(experienceNames[index])),
                      ),
                      onTap: () async {
                        List trip_detail = await getTripDetails(value: experienceNames[index]);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TripsDetailsPage(trips: trip_detail)));
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripsDetailsPage extends StatelessWidget {
  final List trips;

  const TripsDetailsPage({Key? key, required this.trips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips List'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          var trip = trips[index];
          return ListTile(
            title: Text(trip['name']),
            subtitle: Text(trip['category']),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailPage(trip: trip),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
