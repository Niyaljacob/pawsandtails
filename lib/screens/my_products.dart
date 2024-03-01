import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/products_acceptes_user.dart';
import 'package:paws_and_tail/screens/products_decline_user.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

   @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
          backgroundColor: TColo.primaryColor1,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Successfull Orders'),
              Tab(text: 'UnSuccessfull Orders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductsAcceptesUser(),
            ProductsDeclineUser(),
          ],
        ),
      ),
    );
  }
}