import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCartSale extends StatelessWidget {
  const ProductCartSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Cart Sales'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('product_cart_payment').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
              child: Text('No sales available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return _buildProductContainer(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductContainer(Map<String, dynamic> data) {
  final List<dynamic> products = data['products'];

  return Container(
    margin: EdgeInsets.all(10.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Details:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Full Name: ${data['fullName']}'),
        Text('Email: ${data['email']}'),
        Text('Phone Number: ${data['phoneNumber']}'),
        Text('Address: ${data['address']}'),
        Text('Payment Method: ${data['paymentMethod']}'),
        Divider(),
        Text('Product Details:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Column( // Use Column to display each product name separately
          crossAxisAlignment: CrossAxisAlignment.start,
          children: products.map<Widget>((product) {
            return Text('Product Name: ${product['name'] ?? 'Name Not Available'}');
          }).toList(),
        ),
        Text('Total Price: Rs ${data['totalPrice']}'),
      ],
    ),
  );
}

}
