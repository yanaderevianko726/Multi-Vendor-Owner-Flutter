import 'package:efood_multivendor_restaurant/data/model/response/attr.dart';
import 'package:flutter/material.dart';

class AttributeModel {
  Attr attribute;
  bool active;
  TextEditingController controller;
  List<String> variants;

  AttributeModel({@required this.attribute, @required this.active, @required this.controller, @required this.variants});
}