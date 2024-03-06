import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/dog_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCard extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ProductCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dogDetails').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: TColo.gray);
        }

        final dogs = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: dogs.length > 4 ? 4 : dogs.length, // Limit to the first 4 items
          itemBuilder: (context, index) {
            var dog = dogs[index];
            String dogId = dog.id;
            String dogName = dog['name'];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return DogDetails(
                    dogId: dogId,
                    dogName: dogName,
                  );
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white, // Set the card background color to white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CachedNetworkImage(
                        imageUrl: dog['imageurls'][0],
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      dogName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs ${dog['price'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: TColo.primaryColor1),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () {
                        addToCart(dog['imageurls'], dogName, dog['price'], context);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addToCart(List<dynamic> imageUrls, String dogName, dynamic price, BuildContext context) {
    String userId = getCurrentUserId();
    String? userEmail = getCurrentUserEmail();
    // Here you can add the details to the 'dog_cart' collection in Firestore
    FirebaseFirestore.instance.collection('dog_cart').add({
      'imageUrls': imageUrls,
      'dogName': dogName,
      'price': price,
      'userId': userId,
      'userEmail': userEmail,
      // You can add more fields as needed
    }).then((value) {
      // Successfully added to cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item added to cart successfully!'),
        ),
      );
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add item to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User is not logged in.');
    }
  }

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      throw Exception('User is not logged in.');
    }
  }
}



class ProductCardViewMore extends StatefulWidget {
  const ProductCardViewMore({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductCardViewMoreState createState() => _ProductCardViewMoreState();
}

class _ProductCardViewMoreState extends State<ProductCardViewMore> {
  String _searchQuery = '';
  String _selectedPriceFilter = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search for dogs',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _showFilterDialog(context);
              },
              icon: const Icon(Icons.filter_list),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              "Let's find a puppy you'll love.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 15),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('dogDetails').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: TColo.gray);
            }

            final dogs = snapshot.data!.docs;
            final filteredDogs = dogs.where((dog) {
              final nameMatch = dog['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
              final priceMatch = _filterPrice(dog['price']);
              return nameMatch && priceMatch;
            }).toList();

            if (filteredDogs.isEmpty) {
              return const Center(
                child: Text(
                  'No items found',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredDogs.length,
              itemBuilder: (context, index) {
                var dog = filteredDogs[index];
                String dogId = dog.id;
                String dogName = dog['name'];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return DogDetails(
                        dogId: dogId,
                        dogName: dogName,
                      );
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: CachedNetworkImage(
                                imageUrl: dog['imageurls'][0],
                                height: 80,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              dogName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs ${dog['price'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: TColo.primaryColor1,
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            addToCart(dog['imageurls'], dogName, dog['price'], context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  bool _filterPrice(dynamic price) {
    if (_selectedPriceFilter.isEmpty) {
      return true;
    }

    if (price is String) {
      double? parsedPrice = double.tryParse(price);
      if (parsedPrice == null) {
        return false;
      }
      price = parsedPrice;
    }

    if (_selectedPriceFilter == 'less than 5k') {
      return price < 5000;
    } else if (_selectedPriceFilter == 'less than 10k') {
      return price < 10000;
    } else if (_selectedPriceFilter == 'more than 15k') {
      return price > 15000;
    }

    return true;
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Price Filter'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildFilterItem('less than 5k'),
                _buildFilterItem('less than 10k'),
                _buildFilterItem('more than 15k'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedPriceFilter = ''; // Clear the filter
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterItem(String filter) {
    return ListTile(
      title: Text(filter),
      onTap: () {
        setState(() {
          _selectedPriceFilter = filter;
        });
        Navigator.of(context).pop();
      },
    );
  }

  void addToCart(List<dynamic> imageUrls, String dogName, dynamic price, BuildContext context) {
    String userId = getCurrentUserId();
    String? userEmail = getCurrentUserEmail();
    // Here you can add the details to the 'dog_cart' collection in Firestore
    FirebaseFirestore.instance.collection('dog_cart').add({
      'imageUrls': imageUrls,
      'dogName': dogName,
      'price': price,
      'userId': userId,
      'userEmail': userEmail,
      // You can add more fields as needed
    }).then((value) {
      // Successfully added to cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item added to cart successfully!'),
        ),
      );
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add item to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User is not logged in.');
    }
  }

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      throw Exception('User is not logged in.');
    }
  }
}