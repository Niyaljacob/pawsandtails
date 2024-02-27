import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSale extends StatelessWidget {
  const ProductSale({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Sales'),
        backgroundColor: Colors.blue,
      ),
      body: ProductSales(),
    );
  }
}

class ProductSales extends StatelessWidget {
  const ProductSales({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product_payment').snapshots(),
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
            final List<dynamic>? imageURLs = document['imageURLs'];
            final String productName = document['productName'] ?? 'Unknown Product';
            final String priceString = document['price'] ?? '0.0';
            final double price = double.tryParse(priceString.split(' ').last) ?? 0.0;
            final String fullName = document['fullName'] ?? 'Unknown';
            final String email = document['email'] ?? 'Unknown';
            final String phoneNumber = document['phoneNumber'] ?? 'Unknown';
            final String address = document['address'] ?? 'Unknown';

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
                      if (imageURLs != null && imageURLs.isNotEmpty)
                        Image.network(
                          imageURLs[0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(width: 10),
                      Column(
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
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.white),
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
