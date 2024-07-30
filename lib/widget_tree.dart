import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_verification/email_verify_page.dart';
import 'package:firebase_verification/home_page.dart';
import 'package:firebase_verification/login_page.dart';
import 'package:firebase_verification/phone_verify_page.dart';
import 'package:flutter/material.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }else if(user.phoneNumber != null || user.emailVerified){
             return HomePage();
          }
          else if (user.phoneNumber == null){
            return PhoneVerificationScreen();
          }
          else if (!user.emailVerified) {
            return EmailVerificationScreen();
          } else {
            return HomePage();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}