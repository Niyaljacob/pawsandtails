import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogDecline extends StatelessWidget {
  const DogDecline({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DogDeclineProducts(),
    );
  }
}

class DogDeclineProducts extends StatelessWidget {
  const DogDeclineProducts({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dog_decline').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot document = documents[index];
            final List<dynamic> imageUrls = document['imageUrls'];
            final String dogName = document['dogName'];

            // Extract the numerical part of the price string
            final double price = document['price'] as double;

            final String fullName = document['fullName'];
            final String email = document['email'];
            final String phoneNumber = document['phoneNumber'];
            final String address = document['address'];
            final String reason = document['message'];

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        imageUrls[0],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dog Name: $dogName'),
                              Text(
                                  'Price: Rs ${price.toStringAsFixed(2)}'), // Convert double to String
                              Text('Full Name: $fullName'),
                              Text('Email: $email'),
                              Text('Phone Number: $phoneNumber'),
                              Text('Address: $address'),
                              Text(
                                'Reason: $reason',
                                style: const TextStyle(
                                  color:
                                      Colors.red, // Set the text color to red
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
