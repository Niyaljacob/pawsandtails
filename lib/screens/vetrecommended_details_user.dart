import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class VetRecommendedDetailsUser extends StatelessWidget {
  final String productId;
  final String productName;

  const VetRecommendedDetailsUser({
    required this.productId,
    required this.productName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: Text(productName),
      ),
      body: Center(
        child: Text('Product ID: $productId'),
      ),
    );
  }
}
