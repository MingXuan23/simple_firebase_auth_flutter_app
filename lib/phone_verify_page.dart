import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String? _verificationId;

  Future<void> _verifyPhone() async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve the SMS code on Android devices
          await auth.signInWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone number automatically verified and user signed in')),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification code sent to ${_phoneController.text}')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify phone number: $e')),
      );
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );

      final User? user = (await auth.signInWithCredential(credential)).user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully signed in UID: ${user?.uid}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Verification')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone number (+xx xxxxxxxx)'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyPhone,
              child: Text('Verify Phone Number'),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Verification code'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}