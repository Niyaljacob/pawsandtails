import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/top_selling_food.dart'; 

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
         const Text('Recommended Food',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
         const SizedBox(height: 10,),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/foodpop1.png', 'Rottweiler Puppy', 'Brand 1', 'Rs 500.00'),
    _buildProductContainer('assets/foodpop2.png', 'Junior Original', 'Brand 2', 'Rs 2000.00'),
  ],
),
const SizedBox(height: 20,),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/foodpop1.png', 'Rottweiler Puppy', 'Brand 1', 'Rs 500.00'),
    _buildProductContainer('assets/foodpop2.png', 'Junior Original', 'Brand 2', 'Rs 2000.00'),
  ],
),
      ],
    ),
  );
}
Widget _buildFoodItem(Map<String, dynamic> foodItem) {
  return Container(
    decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(25)),
    margin: const EdgeInsets.symmetric(horizontal: 4.0),
    width: MediaQuery.of(context).size.width * .8,
    child: Row(
    
      children: [
        ClipRRect(
  borderRadius: BorderRadius.circular(30), 
  child: Image.asset(
    foodItem['image'],
    height: MediaQuery.of(context).size.height * .2,
    width: MediaQuery.of(context).size.width * .4,
    fit: BoxFit.cover,
  ),
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
     List<Map<String, dynamic>> foodItems = [
    {"name": "Wet Dog - Flea", "kg": "210 ml", "price": "Rs 700.00", "image": "assets/vetpop1.png"},
    {"name": "Orondo Spray", "kg": "250 ml", "price": "Rs 2000.00", "image": "assets/vetpop2.png"},
    {"name": "Petro Mange Cream", "kg": "650 g", "price": "Rs 700.00", "image": "assets/vetpop3.png"},
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
              Image.asset('assets/vetbrands1.webp'),
              Image.asset('assets/vetbrands2.png'),
              Image.asset('assets/vetbrands3.png'),
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
         const Text('Recommended Food',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
         const SizedBox(height: 10,),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/vetpop1.png', 'Wet Dog - Flea', 'Brand 1', 'Rs 700.00'),
    _buildProductContainer('assets/vetpop2.png', 'Petro Mange Cream', 'Brand 2', 'Rs 2000.00'),
  ],
),
const SizedBox(height: 20,),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/vetpop2.png', 'Wet Dog - Flea', 'Brand 1', 'Rs 700.00'),
    _buildProductContainer('assets/vetpop1.png', 'Petro Mange Cream', 'Brand 2', 'Rs 2000.00'),
  ],
),
      ],
    ),
  );
  }




  Widget _accessoriesContent() {
     List<Map<String, dynamic>> foodItems = [
    {"name": "Warm fleece vest", "kg": "210 ml", "price": "Rs 1780.00", "image": "assets/iotpop1.png"},
    {"name": "Pet Nail Clipper", "kg": "250 ml", "price": "Rs 10580.00", "image": "assets/iotpop2.png"},
    {"name": "Flea Comb", "kg": "650 g", "price": "RS 900.00", "image": "assets/iotpop3.png"},
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
              Image.asset('assets/assesbrands1.png'),
              Image.asset('assets/assesbrands2.png'),
              Image.asset('assets/assesbrands3.png'),
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
         const Text('Recommended Food',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
         const SizedBox(height: 10,),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/iotpop1.png', 'Warm fleece vest', 'Brand 1', 'Rs 1780.00'),
    _buildProductContainer('assets/iotpop2.png', 'Pet Nail Clipper', 'Brand 2', 'RS 900.00'),
  ],
),
const SizedBox(height: 20,),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/iotpop2.png', 'Pet Nail Clipper', 'Brand 1', 'RS 900.00'),
    _buildProductContainer('assets/iotpop1.png', 'Warm fleece vest', 'Brand 2', 'Rs 1780.00'),
  ],
),
      ],
    ),
  );
  }




  Widget _iotDeviceContent() {
      List<Map<String, dynamic>> foodItems = [
    {"name": "Automatic Feeder", "kg": "210 ml", "price": "Rs 24489.00", "image": "assets/assespop1.png"},
    {"name": "GPS Pet Tracker", "kg": "250 ml", "price": "Rs 10580.00", "image": "assets/assespop2.png"},
    {"name": "Petcube Pet Camera", "kg": "650 g", "price": "Rs 15965.00", "image": "assets/assespop3.png"},
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
              Image.asset('assets/iotbrands1.jpeg'),
              Image.asset('assets/iotbrands2.png'),
              Image.asset('assets/iotbrands3.jpeg'),
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
         const Text('Recommended Food',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
         const SizedBox(height: 10,),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/assespop1.png', 'Automatic Feeder', 'Brand 1', 'Rs 24489.00'),
    _buildProductContainer('assets/assespop2.png', 'GPS Pet Tracker', 'Brand 2', 'Rs 10580.00'),
  ],
),
const SizedBox(height: 20,),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildProductContainer('assets/assespop2.png', 'GPS Pet Tracker', 'Brand 1', 'Rs 10580.00'),
    _buildProductContainer('assets/assespop1.png', 'Automatic Feeder', 'Brand 2', 'Rs 24489.00'),
  ],
),
      ],
    ),
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



  Widget _buildProductContainer(String imagePath, String productName, String brandName, String price) {
  return Padding(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: GestureDetector(onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return const TopSellingFood();
          }));
    },
      child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20) ),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(20),
              child: Image.asset(imagePath)),
            Divider(),
            Text(productName,style: TextStyle(fontWeight: FontWeight.w500),),
            Text(brandName),
            Text(price,style: TextStyle(color: TColo.primaryColor1),),
          ],
        ),
      ),
    ),
  );
}

}
