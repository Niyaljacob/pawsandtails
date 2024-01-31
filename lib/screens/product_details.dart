import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Golden Retriever'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image at the top
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('adddogs')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator (color: TColo.gray,);
                  }
                  final urls = snapshot.data!.docs
                      .map((doc) => doc['url'] as String)
                      .toList();
                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                       
                      height:MediaQuery.of(context).size.height*.35,
                      enableInfiniteScroll: true,
                      
                      
                      autoPlay: true,
                    ),
                    items: urls
                        .map((url) => Image.network(url, fit: BoxFit.contain))
                        .toList(),
                  );
                },
              ),
              // Horizontal line
              Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              // Additional product details can be added here
              buildProductCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Golden Retriever',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.0),
                Text(
                  'Price: Rs 8000.00',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: TColo.primaryColor1,
                  ),
                ),
              ],
            ),
            Icon(Icons.add_shopping_cart)
          ],
        ),
        SizedBox(height: 35.0),
        _buildDetailItem(context, title: 'Overview', value: '''
The Golden Retriever is a friendly, intelligent, and loyal dog breed known for its golden coat. They excel as family pets, therapy dogs, and in various roles due to their gentle nature and versatility.'''),
        SizedBox(
          height: 25,
        ),
        Text(
          'Details',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline),
        ),
        _buildDetailItem(context, title: 'Gender', value: 'Male'),
        _buildDetailItem(context, title: 'Age', value: '5 Week'),
        _buildDetailItem(context, title: 'Birthday', value: 'December 11 2023'),
        _buildDetailItem(context, title: "Mom's Weight", value: '50 - 55 lbs'),
        _buildDetailItem(context, title: "Dad's Weight", value: '65 - 70 lbs'),
        _buildDetailItem(context, title: "Color", value: 'Light Golden'),
        SizedBox(
          height: 25,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1.1,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle add to cart action
            },
            icon: Icon(
              Icons.shop_two_rounded,
              color: Colors.white,
            ),
            label: Text(
              'Buy',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColo.primaryColor1,
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context,
      {required String title, required String value, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: TColo.primaryColor1),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
