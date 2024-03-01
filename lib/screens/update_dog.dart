import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDog extends StatefulWidget {
  final String dogId;
  final String dogName;

  const UpdateDog({Key? key, required this.dogId, required this.dogName})
      : super(key: key);

  @override
  _UpdateDogState createState() => _UpdateDogState();
}

class _UpdateDogState extends State<UpdateDog> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _priceController = TextEditingController();
  final _overviewController = TextEditingController();
  final _momWeightController = TextEditingController();
  final _dadWeightController = TextEditingController();
  final _colorController = TextEditingController();

  List<String> _imageUrls = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchDogDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: Text(widget.dogName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Dog Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                 keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _overviewController,
                decoration: const InputDecoration(labelText: 'Overview'),
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday'),
              ),
              TextFormField(
                controller: _momWeightController,
                decoration: const InputDecoration(labelText: "Mom's Weight"),
              ),
              TextFormField(
                controller: _dadWeightController,
                decoration: const InputDecoration(labelText: "Dad's Weight"),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: _pickImage,
                child: const Text('Select Image',style: TextStyle(color:Colors.white)),
              ),
              const SizedBox(height: 16),
              _imageUrls.isEmpty
                  ? Container()
                  : CarouselSlider.builder(
                      itemCount: _imageUrls.length,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.3,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return _buildImageCarouselItem(index);
                      },
                    ),
              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: _updateDogDetails,
                child: const Text('Update the Details',style: TextStyle(color:Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarouselItem(int index) {
    return Stack(
      children: [
         CachedNetworkImage(
          imageUrl: _imageUrls[index],
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.delete,color: Colors.red,),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _imageUrls.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _fetchDogDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('dogDetails')
        .doc(widget.dogId)
        .get();
    setState(() {
      _nameController.text = snapshot['name'];
      _ageController.text = snapshot['age'];
      _genderController.text = snapshot['gender'];
      _priceController.text = snapshot['price'];
      _overviewController.text = snapshot['overview'];
      _birthdayController.text = snapshot['birthday'];
      _momWeightController.text = snapshot['mom_weight'];
      _dadWeightController.text = snapshot['dad_weight'];
      _colorController.text = snapshot['color'];
      _imageUrls = List<String>.from(snapshot['imageurls']);
    });
  }

 
  Future<void> _pickImage() async {
  final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    setState(() {
      _uploadImage(pickedImage.path);
    });
  }
}

Future<void> _uploadImage(String imagePath) async {
  Reference ref = FirebaseStorage.instance
      .ref()
      .child('dog_images')
      .child('${DateTime.now().millisecondsSinceEpoch}');
  UploadTask uploadTask = ref.putFile(File(imagePath));
  
  uploadTask.then((res) {
    res.ref.getDownloadURL().then((downloadUrl) {
      setState(() {
        _imageUrls.add(downloadUrl);
      });
    });
  });
}



 Future<void> _updateDogDetails() async {
  final Map<String, dynamic> updatedData = {
    'name': _nameController.text,
    'age': _ageController.text,
    'gender': _genderController.text,
    'price': _priceController.text,
    'overview': _overviewController.text,
    'birthday': _birthdayController.text,
    'mom_weight': _momWeightController.text,
    'dad_weight': _dadWeightController.text,
    'color': _colorController.text,
    'imageurls': _imageUrls,
  };

  try {
    await FirebaseFirestore.instance
        .collection('dogDetails')
        .doc(widget.dogId)
        .update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dog details updated successfully'),
        duration: Duration(seconds: 2), 
      ),
    );
  } catch (error) {
    print('Error updating dog details: $error');
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _priceController.dispose();
    _birthdayController.dispose();
    _momWeightController.dispose();
    _dadWeightController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}
