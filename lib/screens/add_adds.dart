import 'package:carousel_slider/carousel_slider.dart';
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('Adds'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text(
              'Select Images',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 182, 252),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 10), // Add spacing between the button and containers
          Expanded(
            child: ListView.builder(
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return buildImageContainer(screenWidth, _imageUrls[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageContainer(double screenWidth, String imageUrl, int index) {
    return Container(
      height: 160,
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
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
          icon: Icon(Icons.delete),
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

    if (pickedImages != null) {
      for (var image in pickedImages) {
        final ref = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        await _firestore.collection('banners').add({'url': url});
      }
      _fetchImageUrls();
    }
  }

  Future<void> _deleteImage(int index) async {
    final urlToDelete = _imageUrls[index];
    final docToDelete = await _firestore.collection('banners').where('url', isEqualTo: urlToDelete).get();
    docToDelete.docs.forEach((doc) async {
      await _firestore.collection('banners').doc(doc.id).delete();
      await _storage.refFromURL(urlToDelete).delete();
    });
    setState(() {
      _imageUrls.removeAt(index);
    });
  }
}





















  // late List<String?> _selectedImages;
  // final _picker = ImagePicker();
  // final _storage = FirebaseStorage.instance;
  // final _firestore = FirebaseFirestore.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedImages = List.filled(3, null); // Initialize with 3 null values
  // }

  // void _pickImage(int index) async {
  //   final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       _selectedImages[index] = pickedImage.path; // Update the selected image path
  //     });
  //   }
  // }

  // Future<void> _uploadImage(int index) async {
  //   if (_selectedImages[index] != null) {
  //     try {
  //       final file = File(_selectedImages[index]!);
  //       final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //       final ref = _storage.ref().child('ads').child(fileName);
  //       final uploadTask = ref.putFile(file);

  //       await uploadTask.whenComplete(() async {
  //         final url = await ref.getDownloadURL();
  //         // Save the URL to Firestore
  //         await _firestore.collection('banners').add({'url': url});
  //         print('Uploaded image URL: $url');
  //       });
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }

  // void _deleteImage(int index) {
  //   setState(() {
  //     _selectedImages[index] = null; // Remove the image path from the list
  //   });
  // }




   // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 16),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: List.generate(
      //           3,
      //           (index) => Stack(
      //             children: [
      //               GestureDetector(
      //                 onTap: () => _pickImage(index),
      //                 child: Container(
      //                   width: 100,
      //                   height: 100,
      //                   decoration: BoxDecoration(
      //                     border: Border.all(color: Colors.grey),
      //                   ),
      //                   child: _selectedImages[index] != null
      //                       ? Image.asset(_selectedImages[index]!)
      //                       : const Center(child: Text('No Image')),
      //                 ),
      //               ),
      //               if (_selectedImages[index] != null)
      //                 Positioned(
      //                   top: 0,
      //                   right: 0,
      //                   child: IconButton(
      //                     icon: const Icon(Icons.delete),
      //                     onPressed: () => _deleteImage(index),
      //                   ),
      //                 ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 16),
      //       ElevatedButton(
      //         style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all<Color>(
      //             const Color.fromARGB(255, 96, 182, 252),
      //           ),
      //         ),
      //         onPressed: () {
      //           // Upload the selected images
      //           for (int i = 0; i < _selectedImages.length; i++) {
      //             if (_selectedImages[i] != null) {
      //               _uploadImage(i);
      //             }
      //           }
      //         },
      //         child: const Text(
      //           'Upload Images',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),