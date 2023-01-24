import 'package:flutter/material.dart';

class VariantTypeModel {
  String variantType;
  TextEditingController controller;
  FocusNode node;

  VariantTypeModel({@required this.variantType, @required this.controller, @required this.node});
}