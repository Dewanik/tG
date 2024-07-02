import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vyyklhaaerlokvoslcar.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5eWtsaGFhZXJsb2t2b3NsY2FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgwMjcwNjUsImV4cCI6MjAyMzYwMzA2NX0.p_81H973ZvrPBLVkTFJhWeim8RtovyP4ADSqExZEkkA',
  );
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final supb_init = main();
  final supbase = Supabase.instance.client;

  List<List<TextEditingController>> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = _pages.map((page) {
      return List.generate(page['fields'].length, (index) => TextEditingController());
    }).toList();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _insertSupa() async {
    try {
      //These _controllers[i][j] is based on pages fields map created on List<Map<String, dynamic>> _pages update manually as needed.
      final username = _controllers[0][0].text;
      final password = _controllers[0][1].text;
      final email = _controllers[0][2].text;
      final contactNumber = _controllers[0][3].text;

   
      final AuthResponse response2 = await supbase.auth.signUp(
        email: email,
        password: password,
        data:{"isGuide":true},
      );
      final Session? session = response2.session;
      final User? user = response2.user;
   final response1 = await supbase
          .from('user')
          .insert({"username": username, "email": email, "contact_n": contactNumber, "user-id":user?.id});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SignUp Successful!")),
      );
    } on PostgrestException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _insertSupa();
    }
  }

  List<Map<String, dynamic>> get _pages => [
        {
          'fields': [
            {'label': 'Username', 'type': TextInputType.text},
            {'label': 'Password', 'type': TextInputType.visiblePassword, 'isPassword': true},
            {'label': 'Email', 'type': TextInputType.emailAddress},
            {'label': 'Contact Number', 'type': TextInputType.phone},
          ],
          
        },
        
      ];

  Widget _buildSignupPage(List<Map<String, dynamic>> fields, int pageIndex) {
    return SignupPageContent(fields: fields, controllers: _controllers[pageIndex]);
  }

  Widget _buildStepIndicator(int step) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: _currentPage >= step ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStepConnector() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        children: [
          // Steps marker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _pages.length; i++) ...[
                  _buildStepIndicator(i),
                  if (i < _pages.length - 1) _buildStepConnector(),
                ]
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                for (int i = 0; i < _pages.length; i++)
                  _buildSignupPage(_pages[i]['fields'], i)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupPageContent extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final List<TextEditingController> controllers;

  const SignupPageContent({Key? key, required this.fields, required this.controllers})
      : super(key: key);

  @override
  _SignupPageContentState createState() => _SignupPageContentState();
}

class _SignupPageContentState extends State<SignupPageContent> {
  late List<bool> _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = List.generate(widget.fields.length, (index) => widget.fields[index]['isPassword'] ?? false);
  }

  void _toggleVisibility(int index) {
    setState(() {
      _obscureText[index] = !_obscureText[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.fields.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: widget.controllers[i],
                decoration: InputDecoration(
                  labelText: widget.fields[i]['label'],
                  border: OutlineInputBorder(),
                  suffixIcon: widget.fields[i]['isPassword'] == true
                      ? IconButton(
                          icon: Icon(
                            _obscureText[i] ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => _toggleVisibility(i),
                        )
                      : null,
                ),
                keyboardType: widget.fields[i]['type'],
                obscureText: widget.fields[i]['isPassword'] == true ? _obscureText[i] : false,
              ),
            ),
        ],
      ),
    );
  }
}
