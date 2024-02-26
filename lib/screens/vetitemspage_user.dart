import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/stat.dart';
import 'package:paws_and_tail/screens/vetpopular_details_user.dart';
import 'package:paws_and_tail/screens/vetrecommended_details_user.dart';

class VetItemsPage extends StatelessWidget {
  final String searchQuery;
  final String priceFilter;
  const VetItemsPage({super.key, required this.searchQuery, required this.priceFilter});

  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'Top Selling Vet Items Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('VetPopular').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  if (data['imageURLs'] != null &&
                      data['imageURLs'] is List<dynamic>) {
                    String imageUrl = data['imageURLs'][0];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VetPopularDetailsUser(
                          productId: document.id,
                          productName: data['productName'] ?? '',
                          imageURLs: data['imageURLs'] != null &&
                                  data['imageURLs'] is List<dynamic>
                              ? (data['imageURLs'] as List<dynamic>)
                                  .cast<String>()
                              : [], // Convert imageURLs to List<String>
                        ),
                      ),
                    );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(8.0, 8.0),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.77,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: 150,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['productName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data['brandName'],
                                    ),
                                    Text(
                                      'Rs ${data['price']}',
                                      style:
                                          TextStyle(color: TColo.primaryColor1),
                                    ),
                                    const StarRating(
                                        filledStars: 4,
                                        halfFilledStars: 1,
                                        totalStars: 5)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'Top Brands',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('vet_brands').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              return CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * .15,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: documents.map((document) {
                  final String imageUrl = document['image_url'];
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child:CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'Recommended Food',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
       StreamBuilder(
  stream: FirebaseFirestore.instance.collection('Vet Items').snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    // Filter documents based on the search query
    final List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
      return doc['productName'].toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Apply price filter
    if (priceFilter == '<500') {
      filteredDocs.retainWhere((doc) => (doc['price'] ?? 0) < 500);
    } else if (priceFilter == '<1000') {
      filteredDocs.retainWhere((doc) => (doc['price'] ?? 0) < 1000);
    } else if (priceFilter == '>1500') {
      filteredDocs.retainWhere((doc) => (doc['price'] ?? 0) > 1500);
    }

    if (filteredDocs.isEmpty) {
      return const Center(
        child: Text('No items found'),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: filteredDocs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VetRecommendedDetailsUser(
                  productId: document.id,
                  productName: data['productName'] ?? '',
                  imageURLs: data['imageURLs'] != null && data['imageURLs'] is List<dynamic>
                      ? (data['imageURLs'] as List<dynamic>).cast<String>()
                      : [], // Convert imageURLs to List<String>
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: data['imageURLs'] != null && data['imageURLs'] is List<dynamic>
                            ? (data['imageURLs'] as List<dynamic>).isNotEmpty
                                ? (data['imageURLs'] as List<dynamic>)[0]
                                : ''
                            : '',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: 90,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['productName'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Rs ${data['price'] ?? ''}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  },
),
      ],
    );
  }
}
