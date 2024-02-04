import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/intro1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Check if the user is already logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in, navigate to Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => BottomNav()),
        );
      } else {
        // User is not logged in, navigate to Intro
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Intro()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColo.primaryColor1,
      body: Center(
        child: Image.asset('assets/Group 250.png'),
      ),
    );
  }
}
