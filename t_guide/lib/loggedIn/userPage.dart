import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_guide/home/home_banner.dart';
import '../home/LoginPage.dart' as Login;
import 'Lsettings.dart';

class UserData {
  //String name;
  String email;

  UserData({required this.email});
}

class UserPage extends StatefulWidget {
  final UserData userData;

  const UserPage({Key? key, required this.userData}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   final List _pageOptions = [
    HomeApp(),
   SettingsApp()
    
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.userData.email),
              accountEmail: Text(widget.userData.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.userData.email[0],
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => HomeApp()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.push(
                    context,
                   MaterialPageRoute(builder:(context) => _pageOptions.elementAt(_selectedIndex)),
                  );
              },
            ),

             ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context) => _pageOptions.elementAt(_selectedIndex)),
                  );
                final supa_init = Login.supaInit();
                Supabase.instance.client.auth.signOut();
                
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("hello"),
      ),
     
    );
  }
}
