
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/login.dart';

class IntroThree extends StatelessWidget {
  const IntroThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/dogs3.png', // Replace with your image asset
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
                    Text('We Provide',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' selection of lovable dogs \n  available for purchase, \n   providing the perfect \nopportunity for individuals \n  and families to find their \n ideal canine companions.',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>  LoginScreen(),
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
                            'Get Started',
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
        ],
      ),
    );
  }
}