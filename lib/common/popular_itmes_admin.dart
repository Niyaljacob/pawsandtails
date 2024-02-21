import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/stat.dart';

class ProductList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;

  const ProductList({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 197, 197, 197).withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            final List<Widget> productWidgets = documents.take(4).map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductItem(data: data),
              );
            }).toList();

            return ListView(
              scrollDirection: Axis.horizontal,
              children: productWidgets.isNotEmpty ? productWidgets : [const Text('No products found')],
            );
          },
        ),
      ),
    );
  }
}


class ProductItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      width: 350, // Set the desired width
      height: 100, // Set the desired height
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              data['imageURLs'] != null && data['imageURLs'].isNotEmpty
                  ? data['imageURLs'][0]
                  : 'https://via.placeholder.com/150',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['productName'] ?? 'Product Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(data['brandName'] ?? 'Brand Name'),
                Text('Rs ${data['price'] ?? 'Price'}',style: TextStyle(color: TColo.primaryColor1),),
                const StarRating(filledStars: 4, halfFilledStars: 1, totalStars: 5)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
