import 'dart:convert';

import 'package:efood_multivendor_restaurant/controller/addon_controller.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/data/api/api_checker.dart';
import 'package:efood_multivendor_restaurant/data/model/response/attr.dart';
import 'package:efood_multivendor_restaurant/data/model/response/category_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/attribute_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/review_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/variant_type_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/restaurant_repo.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantRepo restaurantRepo;
  RestaurantController({@required this.restaurantRepo});

  List<Product> _productList;
  List<ReviewModel> _restaurantReviewList;
  List<ReviewModel> _productReviewList;
  bool _isLoading = false;
  int _pageSize;
  List<String> _offsetList = [];
  int _offset = 1;
  List<AttributeModel> _attributeList;
  int _discountTypeIndex = 0;
  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  XFile _pickedLogo;
  XFile _pickedCover;
  int _categoryIndex = 0;
  int _subCategoryIndex = 0;
  List<int> _selectedAddons;
  List<VariantTypeModel> _variantTypeList;
  bool _isAvailable = true;
  List<Schedules> _scheduleList;
  bool _scheduleLoading = false;
  bool _isGstEnabled;
  List<int> _categoryIds = [];
  List<int> _subCategoryIds = [];
  int _tabIndex = 0;
  bool _isVeg = false;
  bool _isRestVeg = true;
  bool _isRestNonVeg = true;
  String _type = 'all';
  static List<String> _productTypeList = ['all', 'veg', 'non_veg'];

  List<Product> get productList => _productList;
  List<ReviewModel> get restaurantReviewList => _restaurantReviewList;
  List<ReviewModel> get productReviewList => _productReviewList;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  int get offset => _offset;
  List<AttributeModel> get attributeList => _attributeList;
  int get discountTypeIndex => _discountTypeIndex;
  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get subCategoryList => _subCategoryList;
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  int get categoryIndex => _categoryIndex;
  int get subCategoryIndex => _subCategoryIndex;
  List<int> get selectedAddons => _selectedAddons;
  List<VariantTypeModel> get variantTypeList => _variantTypeList;
  bool get isAvailable => _isAvailable;
  List<Schedules> get scheduleList => _scheduleList;
  bool get scheduleLoading => _scheduleLoading;
  bool get isGstEnabled => _isGstEnabled;
  List<int> get categoryIds => _categoryIds;
  List<int> get subCategoryIds => _subCategoryIds;
  int get tabIndex => _tabIndex;
  bool get isVeg => _isVeg;
  bool get isRestVeg => _isRestVeg;
  bool get isRestNonVeg => _isRestNonVeg;
  String get type => _type;
  List<String> get productTypeList => _productTypeList;

  Future<void> getProductList(String offset, String type) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _productList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await restaurantRepo.getProductList(offset, type);
      if (response.statusCode == 200) {
        if (offset == '1') {
          _productList = [];
        }
        _productList.addAll(ProductModel.fromJson(response.body).products);
        _pageSize = ProductModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Product product) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _pickedLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    Response response = await restaurantRepo.getAttributeList();
    if(response.statusCode == 200) {
      _attributeList = [];
      response.body.forEach((attribute) {
        if(product != null) {
          bool _active = product.attributes.contains(Attr.fromJson(attribute).id);
          List<String> _options = [];
          if(_active) {
            _options.addAll(product.choiceOptions[product.attributes.indexOf(Attr.fromJson(attribute).id)].options);
          }
          _attributeList.add(AttributeModel(
            attribute: Attr.fromJson(attribute),
            active: product.attributes.contains(Attr.fromJson(attribute).id),
            controller: TextEditingController(), variants: _options,
          ));
        }else {
          _attributeList.add(AttributeModel(attribute: Attr.fromJson(attribute), active: false,
            controller: TextEditingController(), variants: [],
          ));
        }
      });
    }else {
      ApiChecker.checkApi(response);
    }
    List<int> _addonsIds = await Get.find<AddonController>().getAddonList();
    if(product != null && product.addOns != null) {
      for(int index=0; index<product.addOns.length; index++) {
        setSelectedAddonIndex(_addonsIds.indexOf(product.addOns[index].id), false);
      }
    }
    generateVariantTypes(product);
    await getCategoryList(product);
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void toggleAttribute(int index, Product product) {
    _attributeList[index].active = !_attributeList[index].active;
    generateVariantTypes(product);
    update();
  }

  void addVariant(int index, String variant, Product product) {
    _attributeList[index].variants.add(variant);
    generateVariantTypes(product);
    update();
  }

  void removeVariant(int mainIndex, int index, Product product) {
    _attributeList[mainIndex].variants.removeAt(index);
    generateVariantTypes(product);
    update();
  }

  Future<void> getCategoryList(Product product) async {
    _categoryIds = [];
    _subCategoryIds = [];
    _categoryIds.add(0);
    _subCategoryIds.add(0);
    Response response = await restaurantRepo.getCategoryList();
    if (response.statusCode == 200) {
      _categoryList = [];
      response.body.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
      if(_categoryList != null) {
        for(int index=0; index<_categoryList.length; index++) {
          _categoryIds.add(_categoryList[index].id);
        }
        if(product != null) {
          setCategoryIndex(_categoryIds.indexOf(int.parse(product.categoryIds[0].id)), false);
          await getSubCategoryList(int.parse(product.categoryIds[0].id), product);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSubCategoryList(int categoryID, Product product) async {
    _subCategoryIndex = 0;
    _subCategoryList = [];
    _subCategoryIds = [];
    _subCategoryIds.add(0);
    if(categoryID != 0) {
      Response response = await restaurantRepo.getSubCategoryList(categoryID);
      if (response.statusCode == 200) {
        _subCategoryList = [];
        response.body.forEach((category) => _subCategoryList.add(CategoryModel.fromJson(category)));
        if(_subCategoryList != null) {
          for(int index=0; index<_subCategoryList.length; index++) {
            _subCategoryIds.add(_subCategoryList[index].id);
          }
          if(product != null && product.categoryIds.length > 1) {
            setSubCategoryIndex(_subCategoryIds.indexOf(int.parse(product.categoryIds[1].id)), false);
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
    update();
  }

  Future<void> updateRestaurant(Restaurant restaurant, String token) async {
    _isLoading = true;
    update();
    Response response = await restaurantRepo.updateRestaurant(restaurant, _pickedLogo, _pickedCover, token);
    if(response.statusCode == 200) {
      Get.back();
      Get.find<AuthController>().getProfile();
      showCustomSnackBar('restaurant_settings_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons.contains(index)) {
      _selectedAddons.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons.removeAt(index);
    update();
  }

  Future<void> addProduct(Product product, bool isAdd) async {
    _isLoading = true;
    update();
    Map<String, String> _fields = Map();
    if(_variantTypeList.length > 0) {
      List<int> _idList = [];
      List<String> _nameList = [];
      _attributeList.forEach((attributeModel) {
        if(attributeModel.active) {
          _idList.add(attributeModel.attribute.id);
          _nameList.add(attributeModel.attribute.name);
          String _variantString = '';
          attributeModel.variants.forEach((variant) {
            _variantString = _variantString + '${_variantString.isEmpty ? '' : ','}' + variant.replaceAll(' ', '_');
          });
          _fields.addAll(<String, String>{'choice_options_${attributeModel.attribute.id}': jsonEncode([_variantString])});
        }
      });
      _fields.addAll(<String, String> {
        'attribute_id': jsonEncode(_idList), 'choice_no': jsonEncode(_idList), 'choice': jsonEncode(_nameList)
      });

      for(int index=0; index<_variantTypeList.length; index++) {
        _fields.addAll(<String, String> {'price_${_variantTypeList[index].variantType.replaceAll(' ', '_')}': _variantTypeList[index].controller.text});
      }
    }
    Response response = await restaurantRepo.addProduct(product, _pickedLogo, _fields, isAdd);
    if(response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(isAdd ? 'product_added_successfully'.tr : 'product_updated_successfully'.tr, isError: false);
      getProductList('1', 'all');
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteProduct(int productID) async {
    _isLoading = true;
    update();
    Response response = await restaurantRepo.deleteProduct(productID);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      getProductList('1', 'all');
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void generateVariantTypes(Product product) {
    List<List<String>> _mainList = [];
    int _length = 1;
    bool _hasData = false;
    List<int> _indexList = [];
    _variantTypeList = [];
    _attributeList.forEach((attribute) {
      if(attribute.active) {
        _hasData = true;
        _mainList.add(attribute.variants);
        _length = _length * attribute.variants.length;
        _indexList.add(0);
      }
    });
    if(!_hasData) {
      _length = 0;
    }
    for(int i=0; i<_length; i++) {
      String _value = '';
      for(int j=0; j<_mainList.length; j++) {
        _value = _value + '${_value.isEmpty ? '' : '-'}' + _mainList[j][_indexList[j]];
      }
      if(product != null) {
        double _price = 0;
        for(Variation variation in product.variations) {
          if(variation.type == _value) {
            _price = variation.price;
            break;
          }
        }
        _variantTypeList.add(VariantTypeModel(
          variantType: _value, controller: TextEditingController(text: _price > 0 ? _price.toString() : ''), node: FocusNode(),
        ));
      }else {
        _variantTypeList.add(VariantTypeModel(variantType: _value, controller: TextEditingController(), node: FocusNode()));
      }

      for(int j=0; j<_mainList.length; j++) {
        if(_indexList[_indexList.length-(1+j)] < _mainList[_mainList.length-(1+j)].length-1) {
          _indexList[_indexList.length-(1+j)] = _indexList[_indexList.length-(1+j)] + 1;
          break;
        }else {
          _indexList[_indexList.length-(1+j)] = 0;
        }
      }
    }
  }

  bool hasAttribute() {
    bool _hasData = false;
    for(AttributeModel attribute in _attributeList) {
      if(attribute.active) {
        _hasData = true;
        break;
      }
    }
    return _hasData;
  }

  Future<void> getRestaurantReviewList(int restaurantID) async {
    _tabIndex = 0;
    Response response = await restaurantRepo.getRestaurantReviewList(restaurantID);
    if(response.statusCode == 200) {
      _restaurantReviewList = [];
      response.body.forEach((review) => _restaurantReviewList.add(ReviewModel.fromJson(review)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getProductReviewList(int productID) async {
    _productReviewList = null;
    Response response = await restaurantRepo.getProductReviewList(productID);
    if(response.statusCode == 200) {
      _productReviewList = [];
      response.body.forEach((review) => _productReviewList.add(ReviewModel.fromJson(review)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int productID) async {
    Response response = await restaurantRepo.updateProductStatus(productID, _isAvailable ? 0 : 1);
    if(response.statusCode == 200) {
      getProductList('1', 'all');
      _isAvailable = !_isAvailable;
      showCustomSnackBar('food_status_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void initRestaurantData(Restaurant restaurant) {
    _pickedLogo = null;
    _pickedCover = null;
    _isGstEnabled = restaurant.gstStatus;
    _scheduleList = [];
    _scheduleList.addAll(restaurant.schedules);
    _isRestVeg = restaurant.veg == 1;
    _isRestNonVeg = restaurant.nonVeg == 1;
  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled;
    update();
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = schedule.openingTime + ':00';
    schedule.closingTime = schedule.closingTime + ':00';
    _scheduleLoading = true;
    update();
    Response response = await restaurantRepo.addSchedule(schedule);
    if(response.statusCode == 200) {
      schedule.id = int.parse(response.body['id'].toString());
      _scheduleList.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int scheduleID) async {
    _scheduleLoading = true;
    update();
    Response response = await restaurantRepo.deleteSchedule(scheduleID);
    if(response.statusCode == 200) {
      _scheduleList.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool _notify = true;
    if(_tabIndex == index) {
      _notify = false;
    }
    _tabIndex = index;
    if(_notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestVeg(bool isVeg, bool notify) {
    _isRestVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestNonVeg(bool isNonVeg, bool notify) {
    _isRestNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

}