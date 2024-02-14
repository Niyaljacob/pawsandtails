
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:paws_and_tail/common/color_extention.dart'; 

class VetRecommendedDetailsUser extends StatelessWidget {
  final String productId;
  final String productName;

  const VetRecommendedDetailsUser({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: Text(productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Vet Items').doc(productId).snapshots(),
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

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text('No product details available'),
                    );
                  }

                  var productDetails = snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic> imageURLs = productDetails['imageURLs'] ?? [];
                  
                  if (imageURLs.isEmpty) {
                    return const Center(
                      child: Text('No images available'),
                    );
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                    items: imageURLs.map<Widget>((imageURL) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Image.network(
                              imageURL,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 18,),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Vet Items').doc(productId).snapshots(),
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

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text('No product details available'),
                    );
                  }

                  var productDetails = snapshot.data!.data() as Map<String, dynamic>;
                  String productName = productDetails['productName'] ?? '';
                  String brandName = productDetails['brandName'] ?? '';
                  String price = productDetails['price'] != null ? 'Rs ${productDetails['price']}' : '';
                  String details = productDetails['details'] ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        price,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: TColo.primaryColor1),
                      ),
                      const Divider(),
                      _buildDetailItem('Brand Name', brandName),
                      _buildDetailItem('Details', details),
                      const SizedBox(height: 25),
                      Container(
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}