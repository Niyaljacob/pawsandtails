import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/productcard.dart';

class DogViewMore extends StatelessWidget {
  const DogViewMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(backgroundColor: TColo.primaryColor1,
        title: const Text(
          'Dogs'
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20,),
             Text(
                    "Let's find a puppy you'll love.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20,),
            ProductCardViewMore(),
          ],
        ),
      ),
    );
  }
}