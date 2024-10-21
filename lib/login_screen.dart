import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
                prefixText: '+',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendOTP(),
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Verification failed: ${e.message}'),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(verificationId: verificationId),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP Sent')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
    }
  }
}