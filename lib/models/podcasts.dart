class Podcast {
  final String image;
  final String title;
  final String name;
  final String podcast;
  final String url;

  Podcast({
    required this.image,
    required this.title,
    required this.name,
    required this.podcast,
    required this.url,
  });

  // Factory constructor to create a Podcast from a map (for JSON parsing if needed)
  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      image: map['image'],
      title: map['title'],
      name: map['name'],
      podcast: map['podcast'],
      url: map['url'],
    );
  }

  // Method to convert the Podcast object to a map (for JSON encoding if needed)
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'name': name,
      'podcast': podcast,
      'url': url,
    };
  }
}
