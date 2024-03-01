import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsAcceptesUser extends StatelessWidget {
  const ProductsAcceptesUser({Key? key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product_accepted')
            .where('email', isEqualTo: userEmail)
            .snapshots(),
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

          if (documents.isEmpty) {
            return const Center(
              child: Text(
                'No items to display',
                style: TextStyle(fontSize: 16),
              ),
            );
          }


          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = documents[index];
              final List<dynamic> imageURLs = document['imageURLs'];
              final String productName = document['productName'];
              final double price = document['price'];
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
                         CachedNetworkImage(
                          imageUrl: imageURLs[0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product Name: $productName'),
                                Text('Price: Rs $price'),
                                Text('Full Name: $fullName'),
                                Text('Email: $email'),
                                Text('Phone Number: $phoneNumber'),
                                Text('Address: $address'),
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
      ),
    );
  }
}

