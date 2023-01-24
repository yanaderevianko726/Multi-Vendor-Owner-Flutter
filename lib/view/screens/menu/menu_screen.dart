import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/menu_model.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, backgroundColor: Color(0xFF4389FF), route: RouteHelper.getProfileRoute()),
      // MenuModel(icon: Images.restaurant, title: 'restaurant'.tr, backgroundColor: Color(0xFFA9B9F1), route: RouteHelper.getRestaurantRoute()),
      // MenuModel(icon: Images.dollar, title: 'wallet'.tr, backgroundColor: Color(0xFFF7BC7E), route: RouteHelper.getWalletRoute()),
      MenuModel(icon: Images.credit_card, title: 'bank_info'.tr, backgroundColor: Color(0xFF448AFF), route: RouteHelper.getBankInfoRoute()),
      //MenuModel(icon: Images.pos, title: 'pos'.tr, backgroundColor: Color(0xFF448AFF), route: RouteHelper.getPosRoute()),
      MenuModel(
        icon: Images.add_food, title: 'add_food'.tr, backgroundColor: Color(0xFFFF8A80), route: RouteHelper.getProductRoute(null),
        isBlocked: !Get.find<AuthController>().profileModel.restaurants[0].foodSection,
      ),
      MenuModel(icon: Images.campaign, title: 'campaign'.tr, backgroundColor: Color(0xFFFF8A80), route: RouteHelper.getCampaignRoute()),
      MenuModel(icon: Images.addon, title: 'addons'.tr, backgroundColor: Color(0xFFFF8A80), route: RouteHelper.getAddonsRoute()),
      MenuModel(icon: Images.categories, title: 'categories'.tr, backgroundColor: Color(0xFFFF8A80), route: RouteHelper.getCategoriesRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, backgroundColor: Color(0xFF62889C), route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, backgroundColor: Color(0xFF62889C), route: RouteHelper.getPrivacyRoute()),
      MenuModel(icon: Images.terms, title: 'terms_condition'.tr, backgroundColor: Color(0xFF62889C), route: RouteHelper.getTermsRoute()),
      MenuModel(icon: Images.log_out, title: 'logout'.tr, backgroundColor: Color(0xFFFF4B55), route: ''),
    ];
    if(Get.find<AuthController>().profileModel.restaurants[0].selfDeliverySystem == 1) {
      _menuList.insert(5, MenuModel(
        icon: Images.delivery_man, title: 'delivery_man'.tr, backgroundColor: Color(0xFF448AFF), route: RouteHelper.getDeliveryManRoute(),
      ));
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: (1/1.2),
            crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          itemCount: _menuList.length,
          itemBuilder: (context, index) {
            return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
          },
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

      ]),
    );
  }
}
