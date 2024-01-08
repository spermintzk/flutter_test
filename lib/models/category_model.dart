import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'Shonen',
        iconPath: 'assets/icons/shonen.jpg',
        boxColor: Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'Comedy',
        iconPath: 'assets/icons/comedy.jpg',
        boxColor: Color(0xffC588F2)));

    categories.add(CategoryModel(
        name: 'Action',
        iconPath: 'assets/icons/action.jpg',
        boxColor: Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'Horror',
        iconPath: 'assets/icons/horror.jpg',
        boxColor: Color(0xffC588F2)));

    return categories;
  }
}
