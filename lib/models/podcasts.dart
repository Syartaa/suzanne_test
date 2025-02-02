class Podcast {
  final String id;
  final String title;
  final String shortDescription;
  final String longDescription;
  final String hostName;
  final int categoryId;
  final String thumbnail;
  final String audioUrl;
  final String? filePath;
  final String? duration;
  final int status;

  Podcast({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.hostName,
    required this.categoryId,
    required this.thumbnail,
    required this.audioUrl,
    this.filePath,
    this.duration,
    required this.status,
  });

  // Factory constructor to create a Podcast from a map
  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      id: map['id'].toString(),
      title: map['title'],
      shortDescription: map['short_description'],
      longDescription: map['long_description'],
      hostName: map['host_name'],
      categoryId: map['category_id'],
      thumbnail: map['thumbnail'],
      audioUrl: map['audio_url'],
      filePath: map['file_path'],
      duration: map['duration'],
      status: map['status'],
    );
  }

  // Convert the Podcast object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': int.tryParse(id) ?? id,
      'title': title,
      'short_description': shortDescription,
      'long_description': longDescription,
      'host_name': hostName,
      'category_id': categoryId,
      'thumbnail': thumbnail,
      'audio_url': audioUrl,
      'file_path': filePath,
      'duration': duration,
      'status': status,
    };
  }
}
