import 'package:suzanne_podcast_app/models/topic.dart';

class Schedule {
  final int id;
  final String title;
  final String description;
  final String images;
  final List<Topic> topics;
  final int scheduleTypeId;
  final String createdAt;
  final String updatedAt;
  final String scheduleTypeName;

  Schedule({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.topics,
    required this.scheduleTypeId,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTypeName,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: json['images'],
      topics: (json['topics'] as List<dynamic>)
          .map((topicJson) => Topic.fromJson(topicJson))
          .toList(),
      scheduleTypeId: json['schedule_type_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      scheduleTypeName: json['scheduleTypeName'],
    );
  }
}
