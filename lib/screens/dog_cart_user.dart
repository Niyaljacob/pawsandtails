import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_accept.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_decline.dart';
import 'package:paws_and_tail/screens/dog_cart_sale_order.dart';

class DogCartUser extends StatelessWidget {
  const DogCartUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColo.primaryColor1,
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
            DogCartSaleOrder(),
            DogCartSaleAccept(),
	    DogCartSaleDecline(),
          ],
        ),
      ),
    );
  }
}
