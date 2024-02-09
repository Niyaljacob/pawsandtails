import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDogShow extends StatefulWidget {
  const AddDogShow({Key? key}) : super(key: key);

  @override
  _AddDogShowState createState() => _AddDogShowState();
}

class _AddDogShowState extends State<AddDogShow> {
  List<XFile> selectedImages = [];
  TextEditingController showNameController = TextEditingController();
  TextEditingController postedOnController = TextEditingController();
  TextEditingController eventDetailsController = TextEditingController();
  TextEditingController whereController = TextEditingController();
  TextEditingController whenController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dog Show Events'),
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                autoPlay: false,
              ),
              items: selectedImages.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Image.file(File(image.path)),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: () {
                              deleteImage(image);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            ElevatedButton(style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: getImage,
              child: const Text('Select Image',style: TextStyle(color: Colors.white),),
            ),
            TextFormField(
              controller: showNameController,
              decoration: const InputDecoration(labelText: 'Show Name'),
            ),
            TextFormField(
              controller: postedOnController,
              decoration: const InputDecoration(labelText: 'Posted On'),
            ),
            TextFormField(
              controller: eventDetailsController,
              decoration: const InputDecoration(labelText: 'Event Details'),
            ),
            TextFormField(
              controller: whereController,
              decoration: const InputDecoration(labelText: 'Where'),
            ),
            TextFormField(
              controller: whenController,
              decoration: const InputDecoration(labelText: 'When'),
            ),
            TextFormField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: addDogShowEvent,
              child: const Text('Add',style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(pickedFile);
      });
    }
  }

  void deleteImage(XFile image) {
    setState(() {
      selectedImages.remove(image);
    });
  }

  void addDogShowEvent() async {
    try {
      List<String> imageUrls = [];
      for (XFile image in selectedImages) {
        File file = File(image.path);
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref()
            .child('dog_show_images/${DateTime.now()}_${file.path}')
            .putFile(file);
        String imageUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance.collection('dog_shows').add({
        'showName': showNameController.text,
        'postedOn': postedOnController.text,
        'eventDetails': eventDetailsController.text,
        'where': whereController.text,
        'when': whenController.text,
        'contact': contactController.text,
        'imageUrls': imageUrls,
      });

      setState(() {
        selectedImages.clear();
        showNameController.clear();
        postedOnController.clear();
        eventDetailsController.clear();
        whereController.clear();
        whenController.clear();
        contactController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dog show event added')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add dog show event')));
    }
  }
}
