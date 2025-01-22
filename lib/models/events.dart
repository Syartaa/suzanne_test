class Event {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String eventTime;
  final String location;
  final String image;
  final int status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.image,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
