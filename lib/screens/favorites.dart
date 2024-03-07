import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/db/model/data_model.dart';
import 'package:paws_and_tail/screens/events_details.dart';

Future<List<EventDetailsModel>> _getFavoriteEvents() async {
  final box = await Hive.openBox<EventDetailsModel>('eventDetailsBox');
  return box.values.toList();
}


class FavoriteUser extends StatefulWidget {
  const FavoriteUser({Key? key}) : super(key: key);

  @override
  _FavoriteUserState createState() => _FavoriteUserState();
}

class _FavoriteUserState extends State<FavoriteUser> {
  late Future<List<EventDetailsModel>> _favoriteEventsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteEventsFuture = _getFavoriteEvents();
  }

  Future<void> _removeFromFavorites(String showId) async {
    final box = await Hive.openBox<EventDetailsModel>('eventDetailsBox');
    await box.delete(showId);
    setState(() {
      // Update the favorite events list after removing the item
      _favoriteEventsFuture = _getFavoriteEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: const Text('Favorites'),
      ),
      body: FutureBuilder<List<EventDetailsModel>>(
        future: _favoriteEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }  else {
            final events = snapshot.data!;
            if (events.isEmpty) {
              // Show a message when no favorite items are added
              return const Center(
                child: Text('No favorite items added'),
              );
            }
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetails(
                          showId: event.showId,
                          showName: event.showName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(8.0, 8.0),
                        ),
                      ],
                    ),
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
                              imageUrl: event.imageUrls.first,
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
                                  event.showName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('Posted On: ${event.postedOn}'),
                                trailing: IconButton(
                                  onPressed: () {
                                    _removeFromFavorites(event.showId);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red, // Change color to red
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
        },
      ),
    );
  }
}
