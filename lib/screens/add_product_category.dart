import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProductCategory extends StatefulWidget {
  const AddProductCategory({Key? key}) : super(key: key);

  @override
  AddProductCategoryState createState() => AddProductCategoryState();
}

class AddProductCategoryState extends State<AddProductCategory> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  List<String> categories = ['Food', 'Vet Items', 'Accessories', 'IOT Device'];
  String selectedCategory = 'Food';
  List<XFile> selectedImages = [];

  late FirebaseFirestore firestore;
  late FirebaseStorage storage;

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  Future<void> initializeFlutterFire() async {
    await Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(pickedFile);
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Future<void> uploadProduct() async {
    try {
      List<String> imageURLs = [];

      for (XFile imageFile in selectedImages) {
        File file = File(imageFile.path);
        TaskSnapshot uploadTask = await storage.ref().child('product_images/${DateTime.now()}_${file.path}').putFile(file);
        String imageURL = await uploadTask.ref.getDownloadURL();
        imageURLs.add(imageURL);
      }

      await firestore.collection(selectedCategory).add({
        'productName': productNameController.text,
        'brandName': brandNameController.text,
        'price': double.parse(priceController.text),
        'details': detailsController.text,
        'imageURLs': imageURLs,
      });

      productNameController.clear();
      brandNameController.clear();
      priceController.clear();
      detailsController.clear();

      setState(() {
        selectedImages.clear();
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product uploaded successfully')));
    } catch (e) {
      

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('Add Product Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: getImage,
                child: const Text('Select Image', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(selectedImages.length, (index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 100,
                            child: Image.file(
                              File(selectedImages[index].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              deleteImage(index);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: brandNameController,
                decoration: const InputDecoration(
                  labelText: 'Brand Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  uploadProduct();
                },
                child: const Text('Upload', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    productNameController.dispose();
    brandNameController.dispose();
    priceController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  
}
