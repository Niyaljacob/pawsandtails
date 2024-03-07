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
      height: MediaQuery.of(context).size.height*.15,
      child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        // Use MediaQuery to get the screen width
        final screenWidth = MediaQuery.of(context).size.width;
        final spacing = screenWidth * 0.09; 
    
        return SizedBox(width: spacing);
      },
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
          CircleAvatar(backgroundColor: Colors.white,
            radius: 30,
            backgroundImage: AssetImage(assetPaths[index]),
          ),
        
          Text(getItemText(index)),
        ],
      ),
    );
  }
}


