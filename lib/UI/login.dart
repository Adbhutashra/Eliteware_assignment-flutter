import 'package:eliteware_assignment/Interceptor/interceptor.dart';
import 'package:eliteware_assignment/Model/user_model.dart';
import 'package:eliteware_assignment/UI/timerstopwatch.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = User(email: email, password: password);

    bool isAuthenticated = await Interceptor.authenticate(user);

    if (isAuthenticated && email != "" && password != "") {
      // Navigate to the home screen or perform desired actions
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TimerStopwatchScreen()),
      );
      print('Login successful!');
    } else {
      // Show an error message or perform desired actions for failed login
      print('Login failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null; // Return null for no validation error
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null; // Return null for no validation error
                },
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                    // All fields are valid, submit the form
                    // You can access the field values using _emailController.text and _passwordController.text
                    // Perform your desired actions here
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  // A simple email validation using a regular expression
  // You can customize the regular expression to fit your specific requirements
  final regex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  return regex.hasMatch(email);
}
