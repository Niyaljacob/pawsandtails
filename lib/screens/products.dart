import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/accessoriesPage_user.dart';
import 'package:paws_and_tail/screens/foodpage_user.dart';
import 'package:paws_and_tail/screens/iotdevicespage_user.dart';
import 'package:paws_and_tail/screens/vetitemspage_user.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: const Text('Products'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 45,
                child: SearchTextField(
                  controller: searchController,
                  labelText: 'Search',
                  hintText: 'Search',
                ),
              ),
              const SizedBox(height: 10),
              buildCategoriesRow(context),
              const SizedBox(height: 20),
              SingleChildScrollView(child: buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return FoodPage();
      case 1:
        return VetItemsPage();
      case 2:
        return AccessoriesPage();
      case 3:
        return IotDevicesPage();
      default:
        return Container();
    }
  }

  Widget buildCategoryButton(BuildContext context, String assetPath, String categoryText, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.080,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isSelected ? TColo.primaryColor1 : Colors.white, // Change color based on selection
              image: DecorationImage(
                image: AssetImage(assetPath),
              ),
            ),
          ),
          Text(categoryText),
        ],
      ),
    );
  }

  Widget buildCategoriesRow(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCategoryButton(context, 'assets/button1.png', 'Food', 0),
          buildCategoryButton(context, 'assets/button2.png', 'Vet items', 1),
          buildCategoryButton(context, 'assets/button3.png', 'Accessories', 2),
          buildCategoryButton(context, 'assets/button4.png', 'IOT device', 3),
        ],
      ),
    );
  }
}
