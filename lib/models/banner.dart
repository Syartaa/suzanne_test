import 'dart:convert';

class Banner {
  final int id;
  final String image;
  final String type;
  final String? bannerLink;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Banner({
    required this.id,
    required this.image,
    required this.type,
    this.bannerLink,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON response
  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      image: json['image'],
      type: json['type'],
      bannerLink: json['banner_link'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // To JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'type': type,
      'banner_link': bannerLink,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

List<Banner> bannerFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Banner>.from(jsonData['data'].map((x) => Banner.fromJson(x)));
}

String bannerToJson(List<Banner> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode({'data': dyn});
}
