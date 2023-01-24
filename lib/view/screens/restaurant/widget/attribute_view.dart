import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttributeView extends StatefulWidget {
  final RestaurantController restController;
  final Product product;
  AttributeView({@required this.restController, @required this.product});

  @override
  State<AttributeView> createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        'attribute'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.restController.attributeList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => widget.restController.toggleAttribute(index, widget.product),
              child: Container(
                width: 100, alignment: Alignment.center,
                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: widget.restController.attributeList[index].active ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text(
                  widget.restController.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: widget.restController.attributeList[index].active ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: widget.restController.attributeList.where((element) => element.active).length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.restController.attributeList.length,
        itemBuilder: (context, index) {
          return widget.restController.attributeList[index].active ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [

              Container(
                width: 100, height: 50, alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text(
                  widget.restController.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

              Expanded(child: MyTextField(
                controller: widget.restController.attributeList[index].controller,
                inputAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
                title: false,
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              CustomButton(
                onPressed: () {
                  String _variant = widget.restController.attributeList[index].controller.text.trim();
                  if(_variant.isEmpty) {
                    showCustomSnackBar('enter_a_variant_name'.tr);
                  }else {
                    widget.restController.attributeList[index].controller.text = '';
                    widget.restController.addVariant(index, _variant, widget.product);
                  }
                },
                buttonText: 'add'.tr,
                width: 70, height: 50,
              ),

            ]),

            Container(
              height: 30, margin: EdgeInsets.only(left: 120),
              child: widget.restController.attributeList[index].variants.length > 0 ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                itemCount: widget.restController.attributeList[index].variants.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                    child: Row(children: [
                      Text(widget.restController.attributeList[index].variants[i], style: robotoRegular),
                      InkWell(
                        onTap: () => widget.restController.removeVariant(index, i, widget.product),
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.close, size: 15),
                        ),
                      ),
                    ]),
                  );
                },
              ) : Align(alignment: Alignment.centerLeft, child: Text('no_variant_added_yet'.tr)),
            ),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          ]) : SizedBox();
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.restController.variantTypeList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [

              Expanded(flex: 6, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'variant'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(
                  height: 45, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Text(
                    widget.restController.variantTypeList[index].variantType,
                    style: robotoRegular, textAlign: TextAlign.center, maxLines: 1,
                  ),
                ),
              ])),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(flex: 4, child: MyTextField(
                hintText: 'price'.tr,
                controller: widget.restController.variantTypeList[index].controller,
                focusNode: widget.restController.variantTypeList[index].node,
                nextFocus: index != widget.restController.variantTypeList.length-1 ? widget.restController.variantTypeList[index+1].node : null,
                inputAction: index != widget.restController.variantTypeList.length-1 ? TextInputAction.next : TextInputAction.done,
                isAmount: true,
                amountIcon: true,
              )),

            ]),
          );
        },
      ),
      SizedBox(height: widget.restController.hasAttribute() ? Dimensions.PADDING_SIZE_LARGE : 0),

    ]);
  }
}
