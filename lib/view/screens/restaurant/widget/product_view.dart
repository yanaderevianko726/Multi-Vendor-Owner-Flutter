import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/product_shimmer.dart';
import 'package:efood_multivendor_restaurant/view/base/product_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final ScrollController scrollController;
  final String type;
  final Function(String type) onVegFilterTap;
  ProductView({@required this.scrollController, this.type, this.onVegFilterTap});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().setOffset(1);
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<RestaurantController>().productList != null
          && !Get.find<RestaurantController>().isLoading) {
        int pageSize = (Get.find<RestaurantController>().pageSize / 10).ceil();
        if (Get.find<RestaurantController>().offset < pageSize) {
          Get.find<RestaurantController>().setOffset(Get.find<RestaurantController>().offset+1);
          print('end of the page');
          Get.find<RestaurantController>().showBottomLoader();
          Get.find<RestaurantController>().getProductList(
            Get.find<RestaurantController>().offset.toString(), Get.find<RestaurantController>().type,
          );
        }
      }
    });
    return GetBuilder<RestaurantController>(builder: (restController) {
      return Column(children: [

        type != null ? VegFilterWidget(type: type, onSelected: onVegFilterTap) : SizedBox(),

        restController.productList != null ? restController.productList.length > 0 ? GridView.builder(
          key: UniqueKey(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
            mainAxisSpacing: 0.01,
            childAspectRatio: 4,
            crossAxisCount: 1,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restController.productList.length,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          itemBuilder: (context, index) {
            return ProductWidget(
              product: restController.productList[index],
              index: index, length: restController.productList.length, isCampaign: false,
              inRestaurant: true,
            );
          },
        ) : Center(child: Text('no_food_available'.tr)) : GridView.builder(
          key: UniqueKey(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
            mainAxisSpacing: 0.01,
            childAspectRatio: 4,
            crossAxisCount: 1,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          itemBuilder: (context, index) {
            return ProductShimmer(
              isEnabled: restController.productList == null, hasDivider: index != 19,
            );
          },
        ),

        restController.isLoading ? Center(child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        )) : SizedBox(),
      ]);
    });
  }
}
