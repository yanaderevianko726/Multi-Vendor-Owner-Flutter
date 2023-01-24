import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/category_model.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    bool _isCategory = categoryModel == null;
    if(_isCategory) {
      Get.find<RestaurantController>().getCategoryList(null);
    }else {
      Get.find<RestaurantController>().getSubCategoryList(categoryModel.id, null);
    }

    return Scaffold(
      appBar: CustomAppBar(title: _isCategory ? 'categories'.tr : categoryModel.name),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        List<CategoryModel> _categories;
        if(_isCategory && restController.categoryList != null) {
          _categories = [];
          _categories.addAll(restController.categoryList);
        }else if(!_isCategory && restController.subCategoryList != null) {
          _categories = [];
          _categories.addAll(restController.subCategoryList);
        }
        return _categories != null ? _categories.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            if(_isCategory) {
              await Get.find<RestaurantController>().getCategoryList(null);
            }else {
              await Get.find<RestaurantController>().getSubCategoryList(categoryModel.id, null);
            }
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if(_isCategory) {
                    Get.toNamed(RouteHelper.getSubCategoriesRoute(_categories[index]));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${_categories[index].image}',
                        height: 55, width: 65, fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_categories[index].name, style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        '${'id'.tr}: ${_categories[index].id}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ])),

                  ]),
                ),
              );
            },
          ),
        ) : Center(
          child: Text(_isCategory ? 'no_category_found'.tr : 'no_subcategory_found'.tr),
        ) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
