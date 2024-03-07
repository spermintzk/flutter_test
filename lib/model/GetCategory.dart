import 'dart:convert';

List<GetCategory> getCategoryFromJson(String str) => List<GetCategory>.from(
    json.decode(str).map((x) => GetCategory.fromJson(x)));

String getCategoryToJson(List<GetCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCategory {
  String id;
  String categoryName;

  GetCategory({
    required this.id,
    required this.categoryName,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
        id: json["id"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
      };
}
