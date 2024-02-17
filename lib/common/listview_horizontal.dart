import 'package:flutter/material.dart';

class HorizontalItemList extends StatelessWidget {
  final int itemCount;
  final String Function(int index) getItemText;
  final void Function(int index) onTap;

  const HorizontalItemList({super.key, 
    required this.itemCount,
    required this.getItemText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    List<String> assetPaths = [
      'assets/newicon1.jpg',
      'assets/newicon2.jpg',
      'assets/newicon3.jpg',
      'assets/newicon4.jpg',
    ];

    return GestureDetector(
      onTap: () {
        onTap(index); 
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: CircleAvatar(backgroundColor: Colors.white,
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


