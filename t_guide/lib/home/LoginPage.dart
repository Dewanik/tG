import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'signup_page.dart' as signup; // Import the signup page

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement login logic here
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () {
                  // Implement Google login logic here
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup.SignupPage()),
                  );
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
