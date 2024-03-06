import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:paws_and_tail/screens/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DogDetails extends StatelessWidget {
  final String dogId;
  final String dogName;

  // ignore: use_key_in_widget_constructors
  const DogDetails({Key? key, required this.dogId, required this.dogName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: Text(dogName),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dogDetails')
            .doc(dogId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: TColo.gray));
          }
          var dogData = snapshot.data!.data() as Map<String, dynamic>;
          List<String> imageUrls = List<String>.from(dogData['imageurls']);
          String breed = dogData['name'] ?? 'Unknown breed';
          String price = dogData['price'] != null
              ? 'Rs ${dogData['price']}'
              : 'Price not available';
          String overview = dogData['overview'] ?? 'Overview not available';
          String gender = dogData['gender'] ?? 'Gender not available';
          String age = dogData['age'] ?? 'Age not available';
          String birthday = dogData['birthday'] ?? 'Birthday not available';
          String momWeight =
              dogData['momWeight'] ?? "Mom's weight not available";
          String dadWeight =
              dogData['dadWeight'] ?? "Dad's weight not available";
          String color = dogData['color'] ?? 'Color not available';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
                  items: imageUrls.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          breed,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: TColo.primaryColor1,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
  onPressed: () {
    addToCart(imageUrls, dogName, price, context);
  },
  icon: Icon(Icons.shopping_bag_outlined,color: TColo.primaryColor1,size: 30,),
),

                  ],
                ),
                const SizedBox(height: 35.0),
                _buildDetailItem(context, title: 'Overview', value: overview),
                const SizedBox(height: 25),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                _buildDetailItem(context, title: 'Gender', value: gender),
                _buildDetailItem(context, title: 'Age', value: age),
                _buildDetailItem(context, title: 'Birthday', value: birthday),
                _buildDetailItem(context,
                    title: "Mom's Weight", value: momWeight),
                _buildDetailItem(context,
                    title: "Dad's Weight", value: dadWeight),
                _buildDetailItem(context, title: "Color", value: color),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return Payment(
                          dogName: breed,
                          price: price,
                          imageUrls: imageUrls,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context,
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(List<String> imageUrls, String dogName, String price, BuildContext context) {
  String userId = getCurrentUserId();
  String? userEmail = getCurrentUserEmail();
  // Here you can add the details to the 'dog_cart' collection in Firestore
  FirebaseFirestore.instance.collection('dog_cart').add({
    'imageUrls': imageUrls,
    'dogName': dogName,
    'price': price,
    'userId': userId,
    'userEmail': userEmail,
    // You can add more fields as needed
  }).then((value) {
    // Successfully added to cart
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart successfully!'),
      ),
    );
  }).catchError((error) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add item to cart: $error'),
        backgroundColor: Colors.red,
      ),
    );
  });
}


  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User is not logged in.');
    }
  }

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      throw Exception('User is not logged in.');
    }
  }
}
