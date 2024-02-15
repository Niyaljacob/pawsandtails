import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paws_and_tail/screens/update_dog_show.dart';

class DogShowList extends StatelessWidget {
  const DogShowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
          child:  Center(child: Text('<<<<<sype Left to Delete<<<<<',style: TextStyle(color: Colors.blue),)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('dog_shows').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: Key(document.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteDogShowEvent(document.id);
                      },
                      child: ListTile(
                        leading: Image.network(
                          data['imageUrls'][0], 
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(data['showName']),
                        subtitle: Text('Posted on: ${data['postedOn']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateDogShow(showId: document.id, showName: data['showName'])),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDogShowEvent(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('dog_shows').doc(documentId).delete();
      print('Dog show event deleted successfully');
    } catch (e) {
      print('Error deleting dog show event: $e');
    }
  }
}
