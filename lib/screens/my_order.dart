import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/dog_accept_user.dart';
import 'package:paws_and_tail/screens/dog_decline_user.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
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
            DogAcceptesUser(),
            DogDeclineUser(),
          ],
        ),
      ),
    );
  }
}
