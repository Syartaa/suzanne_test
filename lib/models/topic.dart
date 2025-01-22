class Topic {
  final String title;
  final String description;
  final String? link; // Made nullable
  final String? image; // Made nullable

  Topic({
    required this.title,
    required this.description,
    this.link, // Nullable field
    this.image, // Nullable field
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['title'] ?? 'Untitled', // Default value for missing title
      description: json['description'] ??
          'No description available', // Default value for missing description
      link: json['link'], // Accepts null
      image: json['image'], // Accepts null
    );
  }
}
