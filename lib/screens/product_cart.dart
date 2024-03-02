import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class ProductCart extends StatelessWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the user's email
    String? userEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Cart'),
        backgroundColor: TColo.primaryColor1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product_cart')
            .where('userId', isEqualTo: userEmail) 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            
            return const Center(
              child: Text('No products in the cart'),
            );
          }

          

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> productData =
                  document.data() as Map<String, dynamic>;

              // Add debug prints to check productData

              return ListTile(
                leading: Image.network(
                  productData['imageURLs']?[0] ??
                      'https://via.placeholder.com/150',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                    productData['productName'] ?? 'Product Name Not Available'),
                subtitle:
                    Text('${productData['price'] ?? 'Price Not Available'}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
