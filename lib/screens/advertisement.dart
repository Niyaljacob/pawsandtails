import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_adds.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 182, 252),
        title: Text('Advertisement'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return AddAdds(); 
              }));
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: 100.0,
                alignment: Alignment.center,
                child: Text(
                  'Add Ads',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              // Handle onTap for "Add Brands"
              print('Add Brands tapped');
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: 100.0,
                alignment: Alignment.center,
                child: Text(
                  'Add Brands',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
