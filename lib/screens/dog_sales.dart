import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogSales extends StatelessWidget {
  const DogSales({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Sales'),
        backgroundColor: Colors.blue,
      ),
      body: DogSaless(),
    );
  }
}

class DogSaless extends StatelessWidget {
  const DogSaless({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dog_payment').snapshots(),
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
            final String priceString = document['price'];
            final double price =
                double.tryParse(priceString.split(' ').last) ?? 0.0;

            final String fullName = document['fullName'];
            final String email = document['email'];
            final String phoneNumber = document['phoneNumber'];
            final String address = document['address'];

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dog Name: $dogName'),
                            Text('Price: Rs $price'),
                            Text('Full Name: $fullName'),
                            Text('Email: $email'),
                            Text('Phone Number: $phoneNumber'),
                            Text('Address: $address'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: Colors.white),
                          )),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Decline',
                              style: TextStyle(color: Colors.white)))
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
