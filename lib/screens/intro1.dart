import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/intro2.dart';
import 'package:paws_and_tail/screens/login.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/dogs1.png', // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),

          // Stack Overlay
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                color:
                    Colors.white.withOpacity(0.8), // Adjust opacity as needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset('assets/logo.png'),
                    SizedBox(
                      height: 25,
                    ),
                    Text('Hey! Welcome',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'while you sit and stay - we\n       will go out and play',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const IntroTwo(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColo.primaryColor1,
                        minimumSize: Size(100, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: TextButton(
                onPressed: () {
                   Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>  LoginScreen(),
                          ),
                        );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}