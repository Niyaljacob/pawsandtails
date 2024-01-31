import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDogs extends StatefulWidget {
  const AddDogs({Key? key}) : super(key: key);

  @override
  _AddDogsState createState() => _AddDogsState();
}

class _AddDogsState extends State<AddDogs> {
  List<String> _imageUrls = [];
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _momWeightController = TextEditingController();
  final _dadWeightController = TextEditingController();
  final _colorController = TextEditingController();
  final _priceController = TextEditingController();
  final _overviewController = TextEditingController();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _imageUrls.map((url) {
                  return buildImageContainer(screenWidth, url);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text('Dog Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextFormField(
              controller: _overviewController,
              decoration: InputDecoration(labelText: 'Overview'),
            ),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            TextFormField(
              controller: _momWeightController,
              decoration: InputDecoration(labelText: "Mom's Weight"),
            ),
            TextFormField(
              controller: _dadWeightController,
              decoration: InputDecoration(labelText: "Dad's Weight"),
            ),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change color as per your requirement
              ),
              onPressed: _saveDogDetails,
              child: Text('Save Dog Details', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer(double screenWidth, String imageUrl) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: () => _deleteImage(imageUrl),
        icon: Icon(Icons.delete),
        color: Colors.white,
      ),
    );
  }

  Future<void> _fetchImageUrls() async {
    final snapshot = await _firestore.collection('adddogs').get();
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
        await _firestore.collection('adddogs').add({'url': url});
      }
      _fetchImageUrls();
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    final docToDelete = await _firestore.collection('adddogs').where('url', isEqualTo: imageUrl).get();
    docToDelete.docs.forEach((doc) async {
      await _firestore.collection('adddogs').doc(doc.id).delete();
      await _storage.refFromURL(imageUrl).delete();
    });
    setState(() {
      _imageUrls.remove(imageUrl);
    });
  }

  Future<void> _saveDogDetails() async {
    final dogDetails = {
      'name': _nameController.text,
      'price': _priceController.text,
      'overview': _overviewController.text,
      'gender': _genderController.text,
      'age': _ageController.text,
      'birthday': _birthdayController.text,
      'mom_weight': _momWeightController.text,
      'dad_weight': _dadWeightController.text,
      'color': _colorController.text,
      'imageurls':_imageUrls
    };

    // Save dog details to Firestore
    await _firestore.collection('dogDetails').add(dogDetails);

    // Clear text field controllers after saving
    _nameController.clear();
    _priceController.clear();
    _overviewController.clear();
    _genderController.clear();
    _ageController.clear();
    _birthdayController.clear();
    _momWeightController.clear();
    _dadWeightController.clear();
    _colorController.clear();
    _imageUrls.clear();
  setState(() {
    
  });
    // Show a success message or perform any other action after saving the details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Dog details saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
