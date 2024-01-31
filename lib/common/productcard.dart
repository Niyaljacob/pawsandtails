import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/product_details.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final double price;

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.productName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the tap event here, for example, navigate to a new screen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetails()),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the top
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product price
                  Text(
                    '\Rs$price',
                    style: TextStyle(
                      color: TColo.primaryColor1,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Product name
                  Text(
                    productName,
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                  ),
                  // SizedBox(height: 8),
                  // Horizontal line
                  Divider(
                    color: const Color.fromARGB(255, 186, 46, 46), // Set the color of the divider
                    thickness: 1, // Set the thickness of the divider
                    height: 5, // Set the height of the divider
                  ),
                  SizedBox(height: 8),
                  // Add to Cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              TColo.primaryColor1),
                        ),
                        onPressed: () {
                          // Handle add to cart action
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
