import 'package:efood_multivendor_restaurant/controller/pos_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/cart_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/discount_tag.dart';
import 'package:efood_multivendor_restaurant/view/base/rating_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/pos/widget/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductBottomSheet extends StatelessWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  ProductBottomSheet({@required this.product, this.isCampaign = false, this.cart, this.cartIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool fromCart = cart != null;
    Get.find<PosController>().initData(product, cart);

    return Container(
      width: 550,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<PosController>(builder: (posController) {
        double _startingPrice;
        double _endingPrice;
        if (product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          product.variations.forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = product.price;
        }

        List<String> _variationList = [];
        for (int index = 0; index < product.choiceOptions.length; index++) {
          _variationList.add(product.choiceOptions[index].options[posController.variationIndex[index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = product.price;
        Variation _variation;
        for (Variation variation in product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }

        double _discount = (isCampaign || product.restaurantDiscount == 0) ? product.discount : product.restaurantDiscount;
        String _discountType = (isCampaign || product.restaurantDiscount == 0) ? product.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity = priceWithDiscount * posController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < product.addOns.length; index++) {
          if (posController.addOnActiveList[index]) {
            addonsCost = addonsCost + (product.addOns[index].price * posController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(id: product.addOns[index].id, quantity: posController.addOnQtyList[index]));
            _addOnsList.add(product.addOns[index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        bool _isRestAvailable = DateConverter.isAvailable(product.restaurantOpeningTime, product.restaurantClosingTime);
        bool _isFoodAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);
        bool _isAvailable = _isRestAvailable && _isFoodAvailable;

        CartModel _cartModel = CartModel(
          price: price, discountedPrice: priceWithDiscount, variation: _variation != null ? [_variation] : [],
          discountAmount: (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)), product: product,
          quantity: posController.quantity, addOnIds: _addOnIdList, addOns: _addOnsList, isCampaign: isCampaign,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            ResponsiveHelper.isDesktop(context) ? InkWell(onTap: () => Get.back(), child: Icon(Icons.close)) : SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_DEFAULT, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_DEFAULT,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                //Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl
                            : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${product.image}',
                        width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTag(discount: _discount, discountType: _discountType, fromTop: 20),
                  ]),
                  SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        product.name, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      RatingBar(rating: product.avgRating, size: 15, ratingCount: product.ratingCount),
                      SizedBox(height: 5),
                      Text(
                        '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount,
                            discountType: _discountType)}' : ''}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                      SizedBox(height: 5),
                      price > priceWithDiscount ? Text(
                        '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                      ) : SizedBox(),
                    ]),
                  ),
                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                (product.description != null && product.description.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(product.description, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ) : SizedBox(),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(product.choiceOptions[index].title, style: robotoMedium),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 0.25),
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: product.choiceOptions[index].options.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              posController.setCartVariationIndex(index, i);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color: posController.variationIndex[index] != i ? Theme.of(context).disabledColor.withOpacity(0.2)
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                border: posController.variationIndex[index] != i
                                    ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                              ),
                              child: Text(
                                product.choiceOptions[index].options[i].trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  color: posController.variationIndex[index] != i ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: index != product.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                    ]);
                  },
                ),
                product.choiceOptions.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE) : SizedBox(),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (posController.quantity > 1) {
                          posController.setProductQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(posController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    QuantityButton(
                      onTap: () => posController.setProductQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Addons
                product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('addons'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: product.addOns.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!posController.addOnActiveList[index]) {
                            posController.addAddOn(true, index);
                          } else if (posController.addOnQtyList[index] == 1) {
                            posController.addAddOn(false, index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: posController.addOnActiveList[index] ? 2 : 20),
                          decoration: BoxDecoration(
                            color: posController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: posController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                            boxShadow: posController.addOnActiveList[index]
                            ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)] : null,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(product.addOns[index].name,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  PriceConverter.convertPrice(product.addOns[index].price),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                  ),
                                ),
                              ]),
                            ),
                            posController.addOnActiveList[index] ? Container(
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (posController.addOnQtyList[index] > 1) {
                                        posController.setAddOnQuantity(false, index);
                                      } else {
                                        posController.addAddOn(false, index);
                                      }
                                    },
                                    child: Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(
                                  posController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => posController.setAddOnQuantity(true, index),
                                    child: Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                                : SizedBox(),
                          ]),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                ]) : SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(PriceConverter.convertPrice(priceWithAddons), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                //Add to cart Button

                _isAvailable ? SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: !_isRestAvailable ? Text(
                    'restaurant_is_closed_now'.tr, style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                  ),
                  ) : Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverter.convertStringTimeToTime(product.availableTimeStarts)} '
                          '- ${DateConverter.convertStringTimeToTime(product.availableTimeEnds)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!product.scheduleOrder && !_isAvailable) ? SizedBox() : CustomButton(
                  width: ResponsiveHelper.isDesktop(context) ? size.width / 2.0 : null,
                  /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                      ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                  buttonText: isCampaign ? 'order_now'.tr : fromCart ? 'update'.tr : 'add'.tr,
                  onPressed: () {
                    Get.back();
                    if(isCampaign) {

                    }else {
                      Get.find<PosController>().addToCart(_cartModel, cartIndex);
                      showCustomSnackBar(fromCart ? 'item_updated'.tr : 'item_added'.tr, isError: false);
                    }
                  },
                  /*onPressed: (!isExistInCart) ? () {
                    if (!isExistInCart) {
                      Get.back();
                      if(isCampaign) {
                        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                          fromCart: false, cartList: [_cartModel],
                        ));
                      }else {
                        if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning,
                            title: 'are_you_sure_to_reset'.tr,
                            description: 'if_you_continue'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                              _showCartSnackBar(context);
                            },
                          ), barrierDismissible: false);
                        } else {
                          Get.find<CartController>().addToCart(_cartModel, cartIndex);
                          _showCartSnackBar(context);
                        }
                      }
                    }
                  } : null,*/

                ),
              ]),
            ),
          ]),
        );
      }),
    );
  }
}

