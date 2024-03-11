import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/db/model/data_model.dart';
import 'package:paws_and_tail/screens/events_details.dart';

class DogShowList extends StatefulWidget {
  const DogShowList({Key? key}) : super(key: key);

  @override
  State<DogShowList> createState() => _DogShowListState();
}

class _DogShowListState extends State<DogShowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Show Events'),
        backgroundColor: TColo.primaryColor1,
      ),
      body: const DogShowListBody(),
    );
  }
}

class DogShowListBody extends StatefulWidget {
  const DogShowListBody({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DogShowListBodyState createState() => _DogShowListBodyState();
}

class _DogShowListBodyState extends State<DogShowListBody> {
  late List<DocumentSnapshot> dogShows = []; // Initialize dogShows as an empty list

  @override
  void initState() {
    super.initState();
    _fetchDogShows(); 
  }

  Future<void> _fetchDogShows() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('dog_shows').get();
      setState(() {
        dogShows = snapshot.docs;
      });
    } catch (e) {
       // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching dog show: $e'),
        duration: const Duration(seconds: 2), 
      ),
    );
    }
  }

  Future<void> _saveToHive(String showId, Map<String, dynamic> data) async {
    try {
      final eventDetailsModel = EventDetailsModel(
        showId: showId,
        showName: data['showName'],
        imageUrls: List<String>.from(data['imageUrls']),
        postedOn: data['postedOn'],
        eventDetails: data['eventDetails'],
        where: data['where'],
        when: data['when'],
        contact: data['contact'],
        isFavorite: data['isFavorite'] ?? false, 
      );

      final box = await Hive.openBox<EventDetailsModel>('eventDetailsBox');
      await box.put(showId, eventDetailsModel);

       // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item add to Favorite'),
        duration: Duration(seconds: 2), 
      ),
    );
    } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error Item add to Favorite: $e'),
        duration: const Duration(seconds: 2), 
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dogShows.length,
      itemBuilder: (context, index) {
        final dogShow = dogShows[index];
        final data = dogShow.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrls'][0];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(
                  showId: dogShow.id,
                  showName: data['showName'],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(8.0, 8.0),
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          data['showName'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Posted On: ${data['postedOn']}'),
                        trailing: IconButton(
                          onPressed: () {
                            // Toggle isFavorite status
                            bool isCurrentlyFavorite =
                                data['isFavorite'] ?? false;
                            _saveToHive(dogShow.id, {
                              ...data,
                              'isFavorite': !isCurrentlyFavorite,
                            });
                          },
                          icon: Icon(
                            data['isFavorite'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: data['isFavorite'] == true
                                ? Colors.red
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
