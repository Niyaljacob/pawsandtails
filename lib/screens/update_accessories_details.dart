import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccessoriesDetails extends StatefulWidget {
  final String productId;
  final String productName;

  const AccessoriesDetails({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  _AccessoriesDetailsState createState() => _AccessoriesDetailsState();
}

class _AccessoriesDetailsState extends State<AccessoriesDetails> {
  List<String> imageURLs = [];
  List<XFile> selectedImages = [];
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

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
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: getImage,
              child: const Text(
                'Select New Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 30,
            ),
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
            ),
            TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: updateDetails,
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Accessories')
          .doc(widget.productId)
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        imageURLs = List<String>.from(data['imageURLs']);
        productNameController.text = data['productName'];
        brandNameController.text = data['brandName'];
        priceController.text = data['price'].toString();
        detailsController.text = data['details'];
      });
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  void getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(pickedFile);
      });
    }
  }

  void deleteImage(String imageUrl) {
    setState(() {
      imageURLs.remove(imageUrl);
    });
  }

  void deleteSelectedImage(XFile image) {
    setState(() {
      selectedImages.remove(image);
    });
  }

  void updateDetails() async {
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

      await FirebaseFirestore.instance
          .collection('Accessories')
          .doc(widget.productId)
          .update({
        'productName': productNameController.text,
        'brandName': brandNameController.text,
        'price': double.parse(priceController.text),
        'details': detailsController.text,
        'imageURLs': updatedImageURLs,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Details updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update details')));
    }
  }
}
