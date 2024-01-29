import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/review.dart';

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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
              return BottomNav();
            }));
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
              Image.asset(
                'assets/dogdetail.png',
                width: MediaQuery.of(context).size.width, // Set the width to fill the screen
                fit: BoxFit.cover,
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
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
        return Review();
      }));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width:  MediaQuery.of(context).size.width * 1.1,
          child: Card(
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Golden Retriever',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: Rs 8000.00',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: TColo.primaryColor1,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '(4 Reviews)',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0), // Adjust spacing between card and additional fields
        Text(
          'Male • 5 weeks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Birthday: December 11, 2023'),
        Text('Available: February 5, 2024'),
        Text("Mom's Weight: 50 - 55 lbs"),
        Text("Dad's Weight: 65 - 70 lbs"),
        Text('Color: Light Golden'),
        SizedBox(height:MediaQuery.of(context).size.height * 0.02, ),
        Container(width: MediaQuery.of(context).size.width * 1.1,
        
          child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle add to cart action
                  },
                  icon: Icon(Icons.add_shopping_cart,color: Colors.white,),
                  label: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: TColo.primaryColor1,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
        ),
      ],
    ),
  );
}

}
