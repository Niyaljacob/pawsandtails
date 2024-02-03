import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/products.dart';
import 'package:paws_and_tail/screens/top_selling_food.dart'; // Import the FoodScreen where _selectedIndex is defined

class FoodScreen extends StatefulWidget {
  
  const FoodScreen({Key? key}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
   final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return BottomNav();
            }));
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text('Products'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: SearchTextField(
                  controller: _searchController,
                  labelText: 'Search',
                  hintText: 'Search',
                ),
              ),
              const SizedBox(height: 10),
              buildCategoriesRow(context),
              const SizedBox(height: 20),
              // Display content based on the selected button
              SingleChildScrollView(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Function to display content based on the selected button
  Widget _buildContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _foodContent();
      case 1:
        return _vetItemsContent();
      case 2:
        return _accessoriesContent();
      case 3:
        return _iotDeviceContent();
      default:
        return Container();
    }
  }

  Widget _foodContent() {
  List<Map<String, dynamic>> foodItems = [
    {"name": "Rottweiler Puppy", "kg": "3 kg", "price": "Rs 500.00", "image": "assets/foodpop1.png"},
    {"name": "Junior Original ", "kg": "400 kg", "price": "Rs 2000.00", "image": "assets/foodpop2.png"},
    {"name": "Josera Deluxe", "kg": "900 g", "price": "Rs 1000.00", "image": "assets/foodpop3.png"},
  ];

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Top Selling",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
        const SizedBox(height: 10,),
        GestureDetector(onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return const TopSellingFood();
          }));
        },
          child: Container(
           height: MediaQuery.of(context).size.height * .2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(), 
              itemCount: foodItems.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildFoodItem(foodItems[index]);
              },
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const Text('Top Brands',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
         Container(
          color: Colors.white,
           child: CarouselSlider(
            options: CarouselOptions(
               height: MediaQuery.of(context).size.height * .15,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
              Image.asset('assets/foodbrands1.webp'),
              Image.asset('assets/foodbrands2.webp'),
              Image.asset('assets/foodbrands3.webp'),
            ].map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: image,
                  );
                },
              );
            }).toList(),
                   ),
         ),
          const SizedBox(height: 20,),
         Text('Recommended Food',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
         
      ],
    ),
  );
}
Widget _buildFoodItem(Map<String, dynamic> foodItem) {
  return Container(
    decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(5)),
    margin: const EdgeInsets.symmetric(horizontal: 4.0),
    width: MediaQuery.of(context).size.width * .8,
    child: Row(
    
      children: [
        Image.asset(
          foodItem['image'],
           height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.width * .4,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8.0),
        Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Text(
              foodItem['name'],
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
          foodItem['kg'],
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        Text(
          foodItem['price'],
          style: const TextStyle(fontSize: 14.0, color: Colors.green),
        ),
          ],
        ),
      ],
    ),
  );
}




  Widget _vetItemsContent() {
    return const Column(
      children: [
        Text('Vet Items Content'),
        // Add your vet items content widgets here
      ],
    );
  }

  Widget _accessoriesContent() {
    return const Column(
      children: [
        Text('Accessories Content'),
        // Add your accessories content widgets here
      ],
    );
  }

  Widget _iotDeviceContent() {
    return const Column(
      children: [
        Text('IOT Device Content'),
        // Add your IOT device content widgets here
      ],
    );
  }

  Widget _buildCategoryButton(BuildContext context, String assetPath, String categoryText, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.080,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryButton(context, 'assets/button1.png', 'Food', 0),
          _buildCategoryButton(context, 'assets/button2.png', 'Vet items', 1),
          _buildCategoryButton(context, 'assets/button3.png', 'Accessories', 2),
          _buildCategoryButton(context, 'assets/button4.png', 'IOT device', 3),
        ],
      ),
    );
  }
}
