import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DarkModeProvider(),
      child: SettingsApp(),
    ),
  );
}

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context, darkModeProvider, child) {
        return MaterialApp(
          theme: darkModeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: SettingsScreen(),
        );
      },
    );
  }
}

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: darkModeProvider.isDarkMode,
              onChanged: darkModeProvider.toggleDarkMode,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Notifications'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Notifications settings screen
            },
          ),
          Divider(),
          ListTile(
            title: Text('Other Settings'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Other Settings screen
            },
          ),
        ],
      ),
    );
  }
}
