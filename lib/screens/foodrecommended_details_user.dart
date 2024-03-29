import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/payment_product.dart';

class FoodRecommendedDetailsUser extends StatelessWidget {
  final String productId;
  final String productName;
  final List<String> imageURLs;
  const FoodRecommendedDetailsUser({
    Key? key,
    required this.productId,
    required this.productName,
    required this.imageURLs,
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
                stream: FirebaseFirestore.instance
                    .collection('Food')
                    .doc(productId)
                    .snapshots(),
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

                  var productDetails =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic> imageURLs = productDetails['imageURLs'] ?? [];

                  if (imageURLs.isEmpty) {
                    return const Center(
                      child: Text('No images available'),
                    );
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
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
                            child: CachedNetworkImage(
                              imageUrl: imageURL,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
                stream: FirebaseFirestore.instance
                    .collection('Food')
                    .doc(productId)
                    .snapshots(),
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

                  var productDetails =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String productName = productDetails['productName'] ?? '';
                  String brandName = productDetails['brandName'] ?? '';
                  String price =
                      productDetails['price'] != null ? 'Rs ${productDetails['price']}' : '';
                  String details = productDetails['details'] ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                productName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                price,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: TColo.primaryColor1),
                              ),
                            ],
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.shopping_bag_outlined,color: TColo.primaryColor1,),
                            onPressed: () {
                               _addToCart(context, productId, productName, imageURLs, price);
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                       SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  _getIconForIndex(index),
                  size: 30,
                  color:const Color.fromARGB(255, 78, 172, 81), // Customize icon color here
                ),
                const SizedBox(height: 5),
                Text(
                  _getTextForIndex(index),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    ),
    const Divider(),
                      _buildDetailItem('Brand Name', brandName),
                      _buildDetailItem('Details', details),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1.1,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return PaymentProducts(
                                productName: productName,
                                price: price,
                                imageURLs: imageURLs.cast<String>(), // Convert to String List
                              );
                            }));
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

  void _addToCart(
  BuildContext context,
  String productId,
  String productName,
  List<String> imageURLs,
  String price, // Adding price parameter
) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the user's email
    String? userEmail = user?.email;

    if (userEmail != null) {
      // Store product details in the product_cart collection
      await FirebaseFirestore.instance.collection('product_cart').add({
        'userId': userEmail, // Store user's email as userId
        'productId': productId,
        'productName': productName,
        'imageURLs': imageURLs,
        'price': price, // Storing the price
        // Add more fields if needed
      });

      // Show a confirmation snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Show an error snackbar if user email is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User email is null'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    // Show an error snackbar if adding to cart fails
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding product to cart: $e'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
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

IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.local_shipping; // Free Delivery icon
      case 1:
        return Icons.payment; // Pay on Delivery icon
      case 2:
        return Icons.block; // Non-returnable icon
      case 3:
        return Icons.delivery_dining; // Paws & Tails Delivered icon
      default:
        return Icons.error;
    }
  }

  String _getTextForIndex(int index) {
    switch (index) {
      case 0:
        return 'Free Delivery';
      case 1:
        return 'Pay on Delivery';
      case 2:
        return 'Non-returnable';
      case 3:
        return 'Paws & Tails Delivered';
      default:
        return '';
    }
  }
