import 'package:flutter/material.dart';

class TrustAndSafetyWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const TrustAndSafetyWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 200,
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 10), 
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}





