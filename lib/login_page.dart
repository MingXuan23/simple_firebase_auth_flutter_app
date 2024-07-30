import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_verification/authentication_page.dart';
import 'package:firebase_verification/phone_verify_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user!.emailVerified) {
          // Navigate to home screen
        } else {

          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email before logging in.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),

             ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  RegistrationScreen()));
              },
              child: Text('Register with email'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  PhoneVerificationScreen()));
              },
              child: Text('Register with phone'),
            ),
          ],
        ),
      ),
    );
  }
}