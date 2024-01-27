import 'package:flutter/material.dart';

class HorizontalItemList extends StatelessWidget {
  final int itemCount;
  final String Function(int index) getItemText;
  final void Function(int index) onTap;

  HorizontalItemList({
    required this.itemCount,
    required this.getItemText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return buildItem(context, index);
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    // Asset paths for demonstration (replace with your actual asset paths)
    List<String> assetPaths = [
      'assets/list1.png',
      'assets/list2.png',
      'assets/list3.png',
      'assets/list4.png',
    ];

    return GestureDetector(
      onTap: () {
        onTap(index); // Trigger the onTap callback with the index
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(assetPaths[index]),
            ),
          ),
        
          Text(getItemText(index)),
        ],
      ),
    );
  }
}


