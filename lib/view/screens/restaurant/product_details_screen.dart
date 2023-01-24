import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  ProductDetailsScreen({@required this.product});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().setAvailability(product.status == 1);
    if(Get.find<AuthController>().profileModel.restaurants[0].reviewsSection) {
      Get.find<RestaurantController>().getProductReviewList(product.id);
    }
    return Scaffold(
      appBar: CustomAppBar(title: 'food_details'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${product.image}',
                    height: 70, width: 80, fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    product.name, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${'price'.tr}: ${product.price}', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  ),
                  Row(children: [
                    Expanded(child: Text(
                      '${'discount'.tr}: ${product.discount} ${product.discountType == 'percent' ? '%'
                          : Get.find<SplashController>().configModel.currencySymbol}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: robotoRegular,
                    )),
                    Get.find<SplashController>().configModel.toggleVegNonVeg ? Container(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        product.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white),
                      ),
                    ) : SizedBox(),
                  ]),
                ])),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Row(children: [
                Text('daily_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: Text(
                  '${DateConverter.convertStringTimeToTime(product.availableTimeStarts)}'
                      ' - ${DateConverter.convertStringTimeToTime(product.availableTimeEnds)}',
                  maxLines: 1,
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                )),
                FlutterSwitch(
                  width: 100, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                  activeText: 'available'.tr, inactiveText: 'unavailable'.tr, activeColor: Theme.of(context).primaryColor,
                  value: restController.isAvailable, onToggle: (bool isActive) {
                    restController.toggleAvailable(product.id);
                  },
                ),
              ]),

              Row(children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                Text(product.avgRating.toStringAsFixed(1), style: robotoRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(
                  '${product.ratingCount} ${'ratings'.tr}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


              product.variations.length > 0 ? Text('variations'.tr, style: robotoMedium) : SizedBox(),
              SizedBox(height: product.variations.length > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              product.variations.length > 0 ? ListView.builder(
                itemCount: product.variations.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(children: [

                    Text(product.variations[index].type+':', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      PriceConverter.convertPrice(product.variations[index].price),
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),

                  ]);
                },
              ) : SizedBox(),
              SizedBox(height: product.variations.length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

              product.addOns.length > 0 ? Text('addons'.tr, style: robotoMedium) : SizedBox(),
              SizedBox(height: product.addOns.length > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              product.addOns.length > 0 ? ListView.builder(
                itemCount: product.addOns.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(children: [

                    Text(product.addOns[index].name+':', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      PriceConverter.convertPrice(product.addOns[index].price),
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),

                  ]);
                },
              ) : SizedBox(),
              SizedBox(height: product.addOns.length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

              (product.description != null && product.description.isNotEmpty) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('description'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(product.description, style: robotoRegular),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                ],
              ) : SizedBox(),

              Get.find<AuthController>().profileModel.restaurants[0].reviewsSection ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('reviews'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  restController.productReviewList != null ? restController.productReviewList.length > 0 ? ListView.builder(
                    itemCount: restController.productReviewList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ReviewWidget(
                        review: restController.productReviewList[index], fromRestaurant: false,
                        hasDivider: index != restController.productReviewList.length-1,
                      );
                    },
                  ) : Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                    child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                  ) : Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ) : SizedBox(),

            ]),
          )),

          CustomButton(
            onPressed: () {
              if(Get.find<AuthController>().profileModel.restaurants[0].foodSection) {
                // TODO: add product
                Get.toNamed(RouteHelper.getProductRoute(product));
              }else {
                showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
              }
            },
            buttonText: 'update_food'.tr,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ),

        ]);
      }),
    );
  }
}
