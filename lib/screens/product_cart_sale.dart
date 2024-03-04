import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/product_cart_sale_accept.dart';
import 'package:paws_and_tail/screens/product_cart_sale_decline.dart';
import 'package:paws_and_tail/screens/product_cart_sale_order.dart';


class ProductCartSale extends StatelessWidget {
  const ProductCartSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('Product Cart Sale'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Accept'),
	      Tab(text: 'Decline'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductCartSaleOrder(),
            ProductCartSaleAccept(),
	    ProductCartSaleDecline(),
          ],
        ),
      ),
    );
  }
}
