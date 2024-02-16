import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/accessorieslist.dart';
import 'package:paws_and_tail/screens/foodlist.dart';
import 'package:paws_and_tail/screens/iotdevice_list.dart';
import 'package:paws_and_tail/screens/vetitemslist.dart';

class ListProductCategory extends StatelessWidget {
  final int initialTabIndex; 

  const ListProductCategory({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTabIndex, 
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('View Products'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Food'),
              Tab(text: 'Vet Items'),
              Tab(text: 'Accessories'),
              Tab(text: 'IOT Devices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FoodList(),
            VetItemList(),
            AccessoriesList(),
            IotDeviceList(),
          ],
        ),
      ),
    );
  }
}
