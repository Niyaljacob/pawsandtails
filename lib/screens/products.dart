import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/accessoriespage_user.dart';
import 'package:paws_and_tail/screens/foodpage_user.dart';
import 'package:paws_and_tail/screens/iotdevicespage_user.dart';
import 'package:paws_and_tail/screens/vetitemspage_user.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedIndex = 0;
  String searchQuery = '';
  String priceFilter = '';

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
              const SizedBox(height: 10),
              buildSearchBar(context),
              const SizedBox(height: 10),
              buildCategoriesRow(context),
              const SizedBox(height: 10),
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
        return FoodPage(searchQuery: searchQuery, priceFilter: priceFilter);
      case 1:
        return VetItemsPage(searchQuery: searchQuery, priceFilter: priceFilter);
      case 2:
        return AccessoriesPage(searchQuery: searchQuery, priceFilter: priceFilter);
      case 3:
        return IotDevicesPage(searchQuery: searchQuery, priceFilter: priceFilter);
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
      height: MediaQuery.of(context).size.height * 0.15,
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

  Widget buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showPriceFilterDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Less than Rs 500'),
                onTap: () {
                  setState(() {
                    priceFilter = '<500';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Less than Rs 1k'),
                onTap: () {
                  setState(() {
                    priceFilter = '<1000';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('More than Rs 1.5k'),
                onTap: () {
                  setState(() {
                    priceFilter = '>1500';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Clear Filter'),
                onTap: () {
                  setState(() {
                    priceFilter = '';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
