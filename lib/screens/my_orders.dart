import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: TColo.primaryColor1,
      ),
    );
  }
}