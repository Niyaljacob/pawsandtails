import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class TopSellingFood extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TopSellingFood({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: const Text('Rottweiler Puppy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/foodpop1.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10), 
        
              const Text(
                'Rottweiler Puppy', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Brand: Royal Canin',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Price: Rs 500.00', 
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 16), 
              const Text(
                'Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), 
              const Text(
                '''Brighten up your pet's bowl with the colourful corn and beetroot kibble in JosiDog MasterMix! Crunchy and flavourful variety for adult dogs of all sizes, plus a wide range of important nutrients included. No added soya, sugar or milk products. Free from artificial colourings, flavourings and preservatives. Contains animal protein, vitamins & minerals.  
        ''', 
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
            width: MediaQuery.of(context).size.width * 1.1,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle add to cart action
              },
              icon: const Icon(
                Icons.shop_two_rounded,
                color: Colors.white,
              ),
              label: const Text(
                'Buy',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColo.primaryColor1,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
