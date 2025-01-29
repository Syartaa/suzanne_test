class Podcast {
  final String id; // Keeping it as String for flexibility
  final String image;
  final String title;
  final String name;
  final String podcast;
  final String url;

  Podcast({
    required this.id,
    required this.image,
    required this.title,
    required this.name,
    required this.podcast,
    required this.url,
  });

  // Factory constructor to create a Podcast from a map (handling int to String conversion)
  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      id: map['id'].toString(), // Convert int ID to String
      image: map['image'],
      title: map['title'],
      name: map['name'],
      podcast: map['podcast'],
      url: map['url'],
    );
  }

  // Method to convert the Podcast object to a map (ensuring id is stored as int)
  Map<String, dynamic> toMap() {
    return {
      'id': int.tryParse(id) ?? id, // Convert String ID back to int if possible
      'image': image,
      'title': title,
      'name': name,
      'podcast': podcast,
      'url': url,
    };
  }
}
