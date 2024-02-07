import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/accessorieslist.dart';
import 'package:paws_and_tail/screens/foodlist.dart';
import 'package:paws_and_tail/screens/iotdevice.dart';
import 'package:paws_and_tail/screens/vetitemslist.dart';

class ListProductCategory extends StatelessWidget {
  const ListProductCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('View Products'),
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return FoodList();
                  }));
                },
                child: Card(elevation: 7,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                                  width: MediaQuery.of(context).size.width * .9,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(child: Text('List of Food',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                            ),
                          ),
              ),

                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return VetItemList();
                  }));
                          },
                          child: Card(elevation: 7,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                                  width: MediaQuery.of(context).size.width * .9,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(child: Text('List of Vet Items',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return AccessoriesList();
                  }));
                          },
                          child: Card(elevation: 7,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                                  width: MediaQuery.of(context).size.width * .9,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(child: Text('List of Accessories',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return IotDeviceList();
                  }));
                          },
                          child: Card(elevation: 7,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                                  width: MediaQuery.of(context).size.width * .9,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(child: Text('List of IOT Devices',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
}

}