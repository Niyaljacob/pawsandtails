import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListOfDogs extends StatelessWidget {
  const ListOfDogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 182, 252),
        title: Text('List Of Dogs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('dogDetails').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No dogs found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var name = doc['name'];
              var price = doc['price'];
              var imageUrl = doc['imageurls'][0]; // Placeholder for image URL

              return ListTile(
                
                title: Text(name),
                subtitle: Text(price),
                leading: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(imageUrl,fit: BoxFit.cover,),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
