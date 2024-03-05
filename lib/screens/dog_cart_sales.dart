import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_accept_admin.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_decline_admin.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_order_admin.dart';


class DogCartSale extends StatelessWidget {
  const DogCartSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('Dog Cart Sale'),
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
            DogCartSaleOrderAdmin(),
            DogCartSaleAcceptAdmin(),
	    DogCartSaleDeclineAdmin(),
          ],
        ),
      ),
    );
  }
}

