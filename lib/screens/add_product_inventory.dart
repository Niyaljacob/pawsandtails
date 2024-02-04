import 'package:flutter/material.dart';

class AddProductsInventory extends StatelessWidget {
  const AddProductsInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('Add Products'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(elevation: 7,
                child: Container(
                  height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(child: Text('Add Products Category',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                ),
              ),
              SizedBox(height: 30,),
              Card(elevation: 7,
                child: Container(
                  height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(child: Text('Add Top Category',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}