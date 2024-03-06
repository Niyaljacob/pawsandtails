import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/product_cart_accepts_user.dart';
import 'package:paws_and_tail/screens/product_cart_decline_user.dart';

import 'package:paws_and_tail/screens/product_cart_orders_users.dart';


class ProductCartUser extends StatelessWidget {
  const ProductCartUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add & View dog Show Events'),
          backgroundColor: TColo.primaryColor1,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Sucessuful'),
              Tab(text: 'Unsucessful'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductCartOrdersUser(),
            ProductCartAcceptsUser(),
            ProductCartDeclineUser(),
          ],
        ),
      ),
    );
  }
}
