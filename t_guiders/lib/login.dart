import 'package:flutter/material.dart';
import 'package:t_guiders/dash.dart';

import 'signup.dart' as signup;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> supaInit() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vyyklhaaerlokvoslcar.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5eWtsaGFhZXJsb2t2b3NsY2FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgwMjcwNjUsImV4cCI6MjAyMzYwMzA2NX0.p_81H973ZvrPBLVkTFJhWeim8RtovyP4ADSqExZEkkA',
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage(BuildContext context, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  bool _obscureText = true;
  final supb_init = supaInit();
  final supbase = Supabase.instance.client;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final Session? session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>MyDashPage())
                      );
                    }
                    print("checked-in");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guides Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: pwdController,
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
                onPressed: () async {
                  try {
                    final email = emailController.text;
                    final pwd = pwdController.text;
                    final AuthResponse response = await supbase.auth.signInWithPassword(email: email, password: pwd);
                    final Session? session = response.session;
                    final User? user = response.user;
                    
                    if (session != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("SignIn Successful!, Welcome  ${user!.email} ")),
                    );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>MyDashPage())
                      );
                    }
                  } on AuthException catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message)),
                    );
                  }
                },
                child: Text('Login'),
              ),
              
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
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
