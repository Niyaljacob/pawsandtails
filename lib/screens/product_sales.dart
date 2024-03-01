import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/product_acceptes.dart';
import 'package:paws_and_tail/screens/product_decline.dart';
import 'package:paws_and_tail/screens/product_oders.dart';

class ProductSale extends StatelessWidget {
  const ProductSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Sales'),
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Accepts'),
              Tab(text: 'Decline'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductOrders(),
           ProductAcceptes(),
           ProductDecline(),
          ],
        ),
      ),
    );
  }
}
