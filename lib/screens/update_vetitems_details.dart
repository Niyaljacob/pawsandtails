import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VetItemsDetails extends StatefulWidget {
  final String vetId;
  final String vetName;

  const VetItemsDetails({Key? key, required this.vetId, required this.vetName}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VetItemsDetailsState createState() => _VetItemsDetailsState();
}

class _VetItemsDetailsState extends State<VetItemsDetails> {
  List<String> imageURLs = [];
  List<XFile> selectedImages = [];
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  bool addToPopularItems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('Update Details'),
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
                ...imageURLs.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Image.network(url),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                deleteImage(url);
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
                                deleteSelectedImage(image);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                })
              ],
            ),

            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: getImage,
              child: const Text('Select New Image', style: TextStyle(color: Colors.white)),
            ),
            const Divider(),
            const SizedBox(height: 30,),
            TextFormField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: brandNameController,
              decoration: const InputDecoration(labelText: 'Brand Name'),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
               keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20.0),
            CheckboxListTile(
              title: const Text('Add to Popular Items'),
              value: addToPopularItems,
              onChanged: (value) {
                setState(() {
                  addToPopularItems = value!;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: updateVetDetails,
              child: const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVetDetails();
  }

  Future<void> fetchVetDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Vet Items').doc(widget.vetId).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        imageURLs = List<String>.from(data['imageURLs']);
        productNameController.text = data['productName'];
        brandNameController.text = data['brandName'];
        priceController.text = data['price'].toString();
        detailsController.text = data['details'];
      });
    } catch (e) {
       // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to fetch details: $e'),
      ),
    );
    }
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

  void deleteImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  imageURLs.remove(imageUrl);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteSelectedImage(XFile image) {
    setState(() {
      selectedImages.remove(image);
    });
  }

  Future<void> updateVetDetails() async {
    try {
      List<String> updatedImageURLs = [...imageURLs];
      for (XFile image in selectedImages) {
        File file = File(image.path);
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now()}_${file.path}')
            .putFile(file);
        String imageURL = await uploadTask.ref.getDownloadURL();
        updatedImageURLs.add(imageURL);
      }

      // Update details in 'Vet Items' collection
      await FirebaseFirestore.instance.collection('Vet Items').doc(widget.vetId).update({
        'productName': productNameController.text,
        'brandName': brandNameController.text,
        'price': double.parse(priceController.text),
        'details': detailsController.text,
        'imageURLs': updatedImageURLs,
      });
      if (addToPopularItems) {
        await FirebaseFirestore.instance.collection('VetPopular').doc(widget.vetId).set({
          'productName': productNameController.text,
          'brandName': brandNameController.text,
          'price': double.parse(priceController.text),
          'details': detailsController.text,
          'imageURLs': updatedImageURLs,
        });
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vet Items details updated')));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update Vet Item details')));
    }
  }
}
