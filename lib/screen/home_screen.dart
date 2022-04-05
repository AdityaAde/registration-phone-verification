import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registration_phone_number/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Log Out"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
