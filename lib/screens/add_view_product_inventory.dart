import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_product_category.dart';
import 'package:paws_and_tail/screens/list_product_category.dart';

class AddProductsInventory extends StatelessWidget {
  const AddProductsInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('Add & View Products'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return AddProductCategory();
                  }));
                },
                child: Card(elevation: 7,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Center(child: Text('Add Products Category',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return ListProductCategory();
                }));
                },
                child: Card(elevation: 7,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Center(child: Text('view Add Products Category',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
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