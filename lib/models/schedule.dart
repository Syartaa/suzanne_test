import 'package:suzanne_podcast_app/models/events.dart';

class Schedule {
  final int id;
  final String title;
  final String description;
  final String images;
  final int scheduleTypeId;
  final String createdAt;
  final String updatedAt;
  final String scheduleTypeName;
  final List<Event> events; // Now schedules contain events

  Schedule({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.scheduleTypeId,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTypeName,
    required this.events,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] ?? '',
      scheduleTypeId: json['schedule_type_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      scheduleTypeName: json['scheduleTypeName'] ?? '',
      events: (json['events'] as List<dynamic>? ?? []) // Handle potential null
          .map((eventJson) => Event.fromJson(eventJson))
          .toList(),
    );
  }

  // Helper function to update events inside the schedule
  Schedule copyWithEvents(List<Event> newEvents) {
    return Schedule(
      id: id,
      title: title,
      description: description,
      images: images,
      scheduleTypeId: scheduleTypeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      scheduleTypeName: scheduleTypeName,
      events: newEvents, // Replace events with new list
    );
  }
}
