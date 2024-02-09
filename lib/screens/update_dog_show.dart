import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateDogShow extends StatefulWidget {
  final String showId;
  final String showName;

  const UpdateDogShow({Key? key, required this.showId, required this.showName}) : super(key: key);

  @override
  _UpdateDogShowState createState() => _UpdateDogShowState();
}

class _UpdateDogShowState extends State<UpdateDogShow> {
  List<XFile> selectedImages = [];
  List<String> showImageUrls = [];
  TextEditingController showNameController = TextEditingController();
  TextEditingController postedOnController = TextEditingController();
  TextEditingController eventDetailsController = TextEditingController();
  TextEditingController whereController = TextEditingController();
  TextEditingController whenController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDogShowDetails();
  }

  void fetchDogShowDetails() async {
    try {
      DocumentSnapshot dogShowSnapshot =
          await FirebaseFirestore.instance.collection('dog_shows').doc(widget.showId).get();
      Map<String, dynamic> data = dogShowSnapshot.data() as Map<String, dynamic>;

      setState(() {
        showNameController.text = data['showName'];
        postedOnController.text = data['postedOn'];
        eventDetailsController.text = data['eventDetails'];
        whereController.text = data['where'];
        whenController.text = data['when'];
        contactController.text = data['contact'];
        showImageUrls = List<String>.from(data['imageUrls']);
      });
    } catch (e) {
      print('Error fetching dog show details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Details'),
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
              items: [
                ...showImageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Image.network(imageUrl),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                deleteImageUrl(imageUrl);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
                ...selectedImages.map((image) {
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
                }),
              ],
            ),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select New Image'),
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
            ElevatedButton(
              onPressed: updateDogShowEvent,
              child: const Text('Update'),
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

  void deleteImageUrl(String imageUrl) {
    setState(() {
      showImageUrls.remove(imageUrl);
    });
  }

  void updateDogShowEvent() async {
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

      imageUrls.addAll(showImageUrls);

      await FirebaseFirestore.instance.collection('dog_shows').doc(widget.showId).update({
        'showName': showNameController.text,
        'postedOn': postedOnController.text,
        'eventDetails': eventDetailsController.text,
        'where': whereController.text,
        'when': whenController.text,
        'contact': contactController.text,
        'imageUrls': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dog show event updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update dog show event')));
    }
  }
}
