import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Method and Tax Files',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentMethodPage(),
    );
  }
}

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameOnCardController = TextEditingController();

  void _savePaymentMethod() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save the payment method information
      // For example, you can send the information to your backend server here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment method saved!')),
      );
    }
  }

  void _navigateToTaxFilesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaxFilesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Payment Method'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameOnCardController,
                decoration: InputDecoration(labelText: 'Name on Card'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name on card';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _savePaymentMethod,
                child: Text('Save Payment Method'),
              ),
              SizedBox(height: 20.0),
              Divider(),
              ListTile(
                title: Text('View Tax Files/Statements'),
                trailing: Icon(Icons.arrow_forward),
                onTap: _navigateToTaxFilesPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }
}

class TaxFilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Files/Statements'),
      ),
      body: Center(
        child: Text('Here you can view and upload your W2s and tax files.'),
      ),
    );
  }
}
