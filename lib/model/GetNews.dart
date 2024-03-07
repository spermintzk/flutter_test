import 'dart:convert';

GetNews getNewsFromJson(String str) => GetNews.fromJson(json.decode(str));

String getNewsToJson(GetNews data) => json.encode(data.toJson());

class GetNews {
  String success;
  List<Feature> feature;
  List<Feature> news;

  GetNews({
    required this.success,
    required this.feature,
    required this.news,
  });

  factory GetNews.fromJson(Map<String, dynamic> json) => GetNews(
        success: json["success"],
        feature:
            List<Feature>.from(json["feature"].map((x) => Feature.fromJson(x))),
        news: List<Feature>.from(json["news"].map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "feature": List<dynamic>.from(feature.map((x) => x.toJson())),
        "news": List<dynamic>.from(news.map((x) => x.toJson())),
      };
}

class Feature {
  String id;
  String name;
  String status;
  String counter;
  String description;
  String picture;
  DateTime createdAt;

  Feature({
    required this.id,
    required this.name,
    required this.status,
    required this.counter,
    required this.description,
    required this.picture,
    required this.createdAt,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        counter: json["counter"],
        description: json["description"],
        picture: json["picture"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "counter": counter,
        "description": description,
        "picture": picture,
        "created_at": createdAt.toIso8601String(),
      };
}
