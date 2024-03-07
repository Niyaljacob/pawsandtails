import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class EventDetailsModel extends HiveObject {
  @HiveField(0)
  final String showId;

  @HiveField(1)
  final String showName;

  @HiveField(2)
  final List<String> imageUrls;

  @HiveField(3)
  final String postedOn;

  @HiveField(4)
  final String eventDetails;

  @HiveField(5)
  final String where;

  @HiveField(6)
  final String when;

  @HiveField(7)
  final String contact;

  @HiveField(8)
  bool isFavorite; // New field to indicate favorite status

  EventDetailsModel({
    required this.showId,
    required this.showName,
    required this.imageUrls,
    required this.postedOn,
    required this.eventDetails,
    required this.where,
    required this.when,
    required this.contact,
    this.isFavorite = false, // Default value
  });
}
