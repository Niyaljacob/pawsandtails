// import 'package:flutter/material.dart';

// import 'package:paws_and_tail/screens/products.dart'; // Import the FoodScreen where _selectedIndex is defined

// Widget _buildCategoryButton(BuildContext context, String assetPath, String categoryText, int index, VoidCallback onPressed) {
//   return GestureDetector(
//     onTap: onPressed,
//     child: Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.080,
//           width: MediaQuery.of(context).size.width * 0.15,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             color: Colors.white,
//             image: DecorationImage(
//               image: AssetImage(assetPath),
//             ),
//           ),
//         ),
//         Text(categoryText),
//       ],
//     ),
//   );
// }



// Widget buildCategoriesRow(BuildContext context) {
//   return Container(
//     height: MediaQuery.of(context).size.height * 0.11,
//     width: MediaQuery.of(context).size.width * 0.9,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildCategoryButton(context, 'assets/button1.png', 'Food', 0, () {
//           FoodScreen.selectedIndex = 0;
//         }),
//         _buildCategoryButton(context, 'assets/button2.png', 'Vet items', 1, () {
//           FoodScreen.selectedIndex = 1;
//         }),
//         _buildCategoryButton(context, 'assets/button3.png', 'Accessories', 2, () {
//           FoodScreen.selectedIndex = 2;
//         }),
//         _buildCategoryButton(context, 'assets/button4.png', 'IOT device', 3, () {
//           FoodScreen.selectedIndex = 3;
//         }),
//       ],
//     ),
//   );
// }

