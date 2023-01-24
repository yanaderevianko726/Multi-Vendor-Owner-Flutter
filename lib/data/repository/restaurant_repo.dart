import 'dart:convert';

import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRepo {
  final ApiClient apiClient;
  RestaurantRepo({@required this.apiClient});

  Future<Response> getProductList(String offset, String type) async {
    return await apiClient.getData('${AppConstants.PRODUCT_LIST_URI}?offset=$offset&limit=10&type=$type');
  }

  Future<Response> getAttributeList() async {
    return apiClient.getData(AppConstants.ATTRIBUTE_URI);
  }

  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORY_URI);
  }

  Future<Response> getSubCategoryList(int parentID) async {
    return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID');
  }

  Future<Response> updateRestaurant(Restaurant restaurant, XFile logo, XFile cover, String token) async {
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      '_method': 'put', 'name': restaurant.name, 'contact_number': restaurant.phone, 'schedule_order': restaurant.scheduleOrder ? '1' : '0',
      'opening_time': restaurant.availableTimeStarts, 'closeing_time': restaurant.availableTimeEnds,
      'address': restaurant.address, 'minimum_order': restaurant.minimumOrder.toString(), 'delivery': restaurant.delivery ? '1' : '0',
      'take_away': restaurant.takeAway ? '1' : '0', 'gst_status': restaurant.gstStatus ? '1' : '0', 'gst': restaurant.gstCode,
      'delivery_charge': restaurant.deliveryCharge.toString(), 'veg': restaurant.veg.toString(), 'non_veg': restaurant.nonVeg.toString(),
    });
    return apiClient.postMultipartData(
      AppConstants.RESTAURANT_UPDATE_URI, _fields, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }

  Future<Response> addProduct(Product product, XFile image, Map<String, String> attributes, bool isAdd) async {
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'price': product.price.toString(), 'discount': product.discount.toString(),
      'discount_type': product.discountType, 'category_id': product.categoryIds[0].id,
      'available_time_starts': product.availableTimeStarts,
      'available_time_ends': product.availableTimeEnds, 'veg': product.veg.toString(),
      'translations': jsonEncode(product.translations),
    });
    String _addon = '';
    for(int index=0; index<product.addOns.length; index++) {
      _addon = _addon + '${index == 0 ? product.addOns[index].id : ',${product.addOns[index].id}'}';
    }
    _fields.addAll(<String, String> {'addon_ids': _addon});
    if(product.categoryIds.length > 1) {
      _fields.addAll(<String, String> {'sub_category_id': product.categoryIds[1].id});
    }
    if(!isAdd) {
      _fields.addAll(<String, String> {'_method': 'put', 'id': product.id.toString()});
    }
    if(attributes.length > 0) {
      _fields.addAll(attributes);
    }
    return apiClient.postMultipartData(
      isAdd ? AppConstants.ADD_PRODUCT_URI : AppConstants.UPDATE_PRODUCT_URI, _fields, [MultipartBody('image', image)],
    );
  }

  Future<Response> deleteProduct(int productID) async {
    return await apiClient.deleteData('${AppConstants.DELETE_PRODUCT_URI}?id=$productID');
  }

  Future<Response> getRestaurantReviewList(int restaurantID) async {
    return await apiClient.getData('${AppConstants.RESTAURANT_REVIEW_URI}?restaurant_id=$restaurantID');
  }

  Future<Response> getProductReviewList(int productID) async {
    return await apiClient.getData('${AppConstants.PRODUCT_REVIEW_URI}/$productID');
  }

  Future<Response> updateProductStatus(int productID, int status) async {
    return await apiClient.getData('${AppConstants.UPDATE_PRODUCT_STATUS_URI}?id=$productID&status=$status');
  }

  Future<Response> addSchedule(Schedules schedule) async {
    return await apiClient.postData(AppConstants.ADD_SCHEDULE, schedule.toJson());
  }

  Future<Response> deleteSchedule(int scheduleID) async {
    return await apiClient.deleteData('${AppConstants.DELETE_SCHEDULE}$scheduleID');
  }

}