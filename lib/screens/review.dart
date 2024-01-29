import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/add_review.dart';
import 'package:paws_and_tail/screens/product_details.dart';

class Review extends StatelessWidget {
  const Review({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
              return ProductDetails();
            }));
          },
        ),
        title: Text('Review'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
            return AddReview();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: TColo.primaryColor1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile section
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profilePhoto.png'),
                          radius: 30,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Horizontal line
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 16),
                    // Multiline text
                    Text(
                      'We had such an amazing experience getting a golden retriever puppy through PuppySpot. Communication and responsiveness was absolutely perfect!!',
                      style: TextStyle(fontSize: 16),
                    ),
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

