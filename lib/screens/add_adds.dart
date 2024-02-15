
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddAdds extends StatefulWidget {
  const AddAdds({Key? key}) : super(key: key);

  @override
  _AddAddsState createState() => _AddAddsState();
}

class _AddAddsState extends State<AddAdds> {
  List<String> _imageUrls = [];
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Select Image for Adding Advertisement'),
            ElevatedButton(
              onPressed: _pickImages,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 96, 182, 252),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                'Select Images',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 174, 174, 174),
                            blurRadius: 100.0,
                            spreadRadius: 2.0,
                             offset: Offset(10.0, 10.0),
           ),]
           ),
                child: ListView.builder(
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return buildImageContainer(screenWidth, _imageUrls[index], index);
                  },
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer(double screenWidth, String imageUrl, int index) {
    return Container(
      height: 160,
      width: screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => _deleteImage(index),
          icon: const Icon(Icons.delete,color: Colors.red,),
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _fetchImageUrls() async {
    final snapshot = await _firestore.collection('banners').get();
    setState(() {
      _imageUrls = snapshot.docs.map((doc) => doc['url'] as String).toList();
    });
  }

  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage();

    for (var image in pickedImages) {
      final ref = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await _firestore.collection('banners').add({'url': url});
    }
    _fetchImageUrls();
    }

  Future<void> _deleteImage(int index) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _confirmDeleteImage(index);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<void> _confirmDeleteImage(int index) async {
  final urlToDelete = _imageUrls[index];
  final docsToDelete = await _firestore.collection('banners').where('url', isEqualTo: urlToDelete).get();
  
  for (var doc in docsToDelete.docs) {
    await _firestore.collection('banners').doc(doc.id).delete();
    await _storage.refFromURL(urlToDelete).delete();
  }

  setState(() {
    _imageUrls.removeAt(index);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Image deleted successfully'),
      duration: Duration(seconds: 2),
    ),
  );
}
}

















