import 'package:flutter/material.dart';
import '../loggedIn/userPage.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true; // To switch between Login and Signup

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

   _submit() {
    // Implement your login or signup logic here
    final email = _emailController.text;
    final password = _passwordController.text;
    print('Email: $email, Password: $password, FormType: ${_isLogin ? 'Login' : 'Signup'}');
    // You should replace this print statement with your authentication logic
    Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => UserPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: _toggleFormType,
                child: Text(_isLogin ? 'Need an account? Register' : 'Have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
