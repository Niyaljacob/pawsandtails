import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTopBrands extends StatefulWidget {
  const AddTopBrands({Key? key}) : super(key: key);

  @override
  _AddTopBrandsState createState() => _AddTopBrandsState();
}

class _AddTopBrandsState extends State<AddTopBrands> {
  late File _imageFile;
  final picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _selectedBrandType;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Brand Type',
            border: OutlineInputBorder(),
          ),
          value: _selectedBrandType,
          onChanged: (value) {
            setState(() {
              _selectedBrandType = value;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'food',
              child: Text('Food Brand'),
            ),
            DropdownMenuItem(
              value: 'vet',
              child: Text('Vet Brand'),
            ),
            DropdownMenuItem(
              value: 'accessories',
              child: Text('Accessories Brand'),
            ),
            DropdownMenuItem(
              value: 'iot',
              child: Text('IOT Brand'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          onPressed: _pickImage,
          child: const Text('Select Image',style: TextStyle(color: Colors.white),),
        ),
        const SizedBox(height: 20),
        ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          onPressed: _uploadImageToFirestore,
          child: const Text('Upload Image',style: TextStyle(color: Colors.white),),
        ),
        const SizedBox(height: 20),
        const Text(
          'Uploaded Images',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('$_selectedBrandType' '_brands').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final imageUrl = documents[index]['image_url'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Placeholder widget
                  imageUrl: imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () => _deleteImage(documents[index].id),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageToFirestore() async {
    if (_selectedBrandType != null) {
      try {
        final ref = _storage.ref().child('$_selectedBrandType/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_imageFile);
        final url = await ref.getDownloadURL();
        await _firestore.collection('$_selectedBrandType' + '_brands').add({'image_url': url});
        // Show a success snackbar
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image uploaded successfully'),
          duration: Duration(seconds: 2),
        ));
      } catch (error) {
        // Show an error snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error uploading image: $error'),
          duration: const Duration(seconds: 2),
        ));
      }
    } else {
      // Show a warning snackbar if brand type or image is not selected
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a brand type and an image.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _deleteImage(String docId) async {
    try {
      await _firestore.collection('$_selectedBrandType' + '_brands').doc(docId).delete();
      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image deleted successfully'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting image: $error'),
        duration: const Duration(seconds: 2),
      ));
    }
  }
}
