import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;
  Color backgroundColor;
  String route;
  bool isBlocked;

  MenuModel({@required this.icon, @required this.title, @required this.backgroundColor, @required this.route, this.isBlocked = false});
}