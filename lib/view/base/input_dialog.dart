import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialog extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final Function(String value) onPressed;
  InputDialog({@required this.icon, this.title, @required this.description, @required this.onPressed});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Image.asset(widget.icon, width: 50, height: 50),
            ),

            widget.title != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(
                widget.title, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.red),
              ),
            ) : SizedBox(),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(widget.description, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), textAlign: TextAlign.center),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Container(
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).disabledColor), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
              child: CustomTextField(
                maxLines: 1,
                controller: _textEditingController,
                hintText: 'enter_processing_time'.tr,
                isEnabled: true,
                inputType: TextInputType.number,
                inputAction: TextInputAction.done,

              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            GetBuilder<OrderController>(builder: (orderController) {
              return (orderController.isLoading) ? Center(child: CircularProgressIndicator()) : Row(children: [

                Expanded(child: CustomButton(
                  buttonText: 'submit'.tr,
                  onPressed: () {
                    if(_textEditingController.text.trim().isEmpty) {
                      showCustomSnackBar('please_provide_processing_time'.tr);
                    }else {
                      widget.onPressed(_textEditingController.text.trim());
                    }
                  },
                  height: 40,
                )),

                SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                Expanded(child: TextButton(
                  onPressed: ()  => widget.onPressed(null),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  ),
                  child: Text(
                    'cancel'.tr, textAlign: TextAlign.center,
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                )),

              ]);
            }),

          ]),
        ),
      )),
    );
  }
}