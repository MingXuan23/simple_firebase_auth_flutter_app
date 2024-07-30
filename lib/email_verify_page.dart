import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_verification/phone_verify_page.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    user?.reload();
  }

  Future<void> _checkEmailVerification() async {
    await user?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });

    if (user?.emailVerified ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email is not verified yet.')),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    await user?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Verification email sent. Please check your inbox.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${user?.email}'),
            Text('Verified: ${user?.emailVerified}'),
            ElevatedButton(
              onPressed: _checkEmailVerification,
              child: Text('Check Verification Status'),
            ),
            ElevatedButton(
              onPressed: _resendVerificationEmail,
              child: Text('Resend Verification Email'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhoneVerificationScreen()),
                );
              },
              child: Text('Sign in with Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}
