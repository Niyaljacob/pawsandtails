import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogAcceptes extends StatelessWidget {
  const DogAcceptes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('accepted').snapshots(),
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
              final double price = document['price'];
              final String fullName = document['fullName'];
              final String email = document['email'];
              final String phoneNumber = document['phoneNumber'];
              final String address = document['address'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: imageUrls[0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text('Dog Name: $dogName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: Rs $price'),
                      Text('Full Name: $fullName'),
                      Text('Email: $email'),
                      Text('Phone Number: $phoneNumber'),
                      Text('Address: $address'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
