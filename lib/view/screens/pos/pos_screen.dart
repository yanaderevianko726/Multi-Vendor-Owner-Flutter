import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/pos_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/my_text_field.dart';
import 'package:efood_multivendor_restaurant/view/screens/pos/widget/pos_product_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/pos/widget/product_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class PosScreen extends StatefulWidget {
  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).textTheme.bodyText1.color,
          onPressed: () => Get.back(),
        ),
        title: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'search_food'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).hintColor),
              filled: true, fillColor: Theme.of(context).cardColor,
            ),
            style: robotoRegular.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await Get.find<PosController>().searchProduct(pattern);
          },
          itemBuilder: (context, Product suggestion) {
            return Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${suggestion.image}',
                    height: 40, width: 40, fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(suggestion.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                    Text(PriceConverter.convertPrice(suggestion.price), style: robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_SMALL,
                    )),
                  ]),
                ),
              ]),
            );
          },
          onSuggestionSelected: (Product suggestion) {
            _searchController.text = '';
            Get.bottomSheet(ProductBottomSheet(product: suggestion));
          },
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ],
      ),

      body: GetBuilder<PosController>(
        builder: (posController) {
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _addOns = 0;
          double _discount = 0;
          double _tax = 0;
          double _orderAmount = 0;
          Restaurant _restaurant = Get.find<AuthController>().profileModel != null
              ? Get.find<AuthController>().profileModel.restaurants[0] : null;

          if(_restaurant != null) {
            posController.cartList.forEach((cartModel) {

              List<AddOns> _addOnList = [];
              cartModel.addOnIds.forEach((addOnId) {
                for(AddOns addOns in cartModel.product.addOns) {
                  if(addOns.id == addOnId.id) {
                    _addOnList.add(addOns);
                    break;
                  }
                }
              });
              _addOnsList.add(_addOnList);

              _availableList.add(DateConverter.isAvailable(cartModel.product.availableTimeStarts, cartModel.product.availableTimeEnds));

              for(int index=0; index<_addOnList.length; index++) {
                _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
              }
              _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
              double _dis = (_restaurant.discount != null
                  && DateConverter.isAvailable(_restaurant.discount.startTime, _restaurant.discount.endTime, isoTime: true))
                  ? _restaurant.discount.discount : cartModel.product.discount;
              String _disType = (_restaurant.discount != null
                  && DateConverter.isAvailable(_restaurant.discount.startTime, _restaurant.discount.endTime, isoTime: true))
                  ? 'percent' : cartModel.product.discountType;
              _discount = _discount + ((cartModel.price - PriceConverter.convertWithDiscount(cartModel.price, _dis, _disType)) * cartModel.quantity);
            });

            if (_restaurant.discount != null) {
              if (_restaurant.discount.maxDiscount != 0 && _restaurant.discount.maxDiscount < _discount) {
                _discount = _restaurant.discount.maxDiscount;
              }
              if (_restaurant.discount.minPurchase != 0 && _restaurant.discount.minPurchase > (_itemPrice + _addOns)) {
                _discount = 0;
              }
            }
            _orderAmount = (_itemPrice - _discount) + _addOns;
            _tax = PriceConverter.calculation(_orderAmount, _restaurant.tax, 'percent', 1);
          }

          double _subTotal = _itemPrice + _addOns;
          double _total = _subTotal - _discount + _tax;

          if(posController.discount != -1) {
            _discount = posController.discount;
          }

          _discountController.text = _discount.toString();
          _taxController.text = _tax.toString();

          return posController.cartList.length > 0 ? Column(
            children: [

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), physics: BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          // Product
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: posController.cartList.length,
                            itemBuilder: (context, index) {
                              return PosProductWidget(
                                cart: posController.cartList[index], cartIndex: index,
                                addOns: _addOnsList[index], isAvailable: _availableList[index],
                              );
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          // Total
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('item_price'.tr, style: robotoRegular),
                            Text(PriceConverter.convertPrice(_itemPrice), style: robotoRegular),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('addons'.tr, style: robotoRegular),
                            Text('(+) ${PriceConverter.convertPrice(_addOns)}', style: robotoRegular),
                          ]),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('subtotal'.tr, style: robotoMedium),
                            Text(PriceConverter.convertPrice(_subTotal), style: robotoMedium),
                          ]),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(children: [
                            Expanded(child: Text('discount'.tr, style: robotoRegular)),
                            SizedBox(
                              width: 70,
                              child: MyTextField(
                                title: false,
                                controller: _discountController,
                                onSubmit: (text) => posController.setDiscount(text),
                                inputAction: TextInputAction.done,
                              ),
                            ),
                            Text('(-) ${PriceConverter.convertPrice(_discount)}', style: robotoRegular),
                          ]),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('vat_tax'.tr, style: robotoRegular),
                            Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
                          ]),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              'total_amount'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              PriceConverter.convertPrice(_total),
                              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                            ),
                          ]),

                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 1170,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(buttonText: 'order_now'.tr, onPressed: () {
                  if(_availableList.contains(false)) {
                    showCustomSnackBar('one_or_more_product_unavailable'.tr);
                  } else {

                  }
                }),
              ),

            ],
          ) : Center(child: Text('no_food_available'.tr));
        },
      ),
    );
  }
}
