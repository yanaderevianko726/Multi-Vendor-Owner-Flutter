import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:flutter/material.dart';

class RunningOrderModel {
  String status;
  List<OrderModel> orderList;

  RunningOrderModel({@required this.status, @required this.orderList});
}