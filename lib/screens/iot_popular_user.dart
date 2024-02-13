import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class IotPopularDetailsUser extends StatelessWidget {
  final String productId;
  final String productName;

  const IotPopularDetailsUser({
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
      body: Container(
        child: Center(
          child: Text('Product ID: $productId'),
        ),
      ),
    );
  }
}