import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/theme/colors.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/open_times_view.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/product_view.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool _review =
      Get.find<AuthController>().profileModel.restaurants[0].reviewsSection;
  List<Widget> slideImages = [];

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: _review ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController.index);
    });
    Get.find<RestaurantController>().getProductList('1', 'all');
    Get.find<RestaurantController>().getRestaurantReviewList(
        Get.find<AuthController>().profileModel.restaurants[0].id);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<AuthController>(builder: (authController) {
        Restaurant _restaurant = authController.profileModel != null
            ? authController.profileModel.restaurants[0]
            : null;

        slideImages = [
          CustomImage(
            fit: BoxFit.cover,
            placeholder: Images.restaurant_cover,
            height: 220,
            image:
                '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
          ),
          CustomImage(
            fit: BoxFit.cover,
            placeholder: Images.restaurant_cover,
            height: 220,
            image:
                '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${_restaurant.logo}',
          ),
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          floatingActionButton: restController.tabIndex == 0
              ? FloatingActionButton(
                  heroTag: 'nothing',
                  onPressed: () {
                    if (Get.find<AuthController>()
                        .profileModel
                        .restaurants[0]
                        .foodSection) {
                      if (_restaurant != null) {
                        // TODO: add product
                        Get.toNamed(RouteHelper.getProductRoute(null));
                      }
                    } else {
                      showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                    }
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.add_circle_outline,
                      color: Theme.of(context).cardColor, size: 30),
                )
              : null,
          body: _restaurant != null
              ? CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 230,
                      toolbarHeight: 50,
                      pinned: true,
                      floating: false,
                      backgroundColor: Theme.of(context).primaryColor,
                      actions: [
                        IconButton(
                          icon: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL)),
                            child: Image.asset(Images.edit),
                          ),
                          onPressed: () => Get.toNamed(
                              RouteHelper.getRestaurantSettingsRoute(
                                  _restaurant)),
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: ImageSlideshow(
                          width: double.infinity,
                          height: 200,
                          initialPage: 0,
                          indicatorColor: yellowDark,
                          indicatorBackgroundColor: Colors.white,
                          children: slideImages,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          width: 1170,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          color: Theme.of(context).cardColor,
                          child: Column(children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                        _restaurant.name,
                                        style: robotoMedium.copyWith(
                                          fontSize: 18,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _restaurant.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      ),
                                    ])),
                                Container(
                                  width: 64,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${_restaurant.avgRating.toStringAsFixed(1)}/${_restaurant.ratingCount}',
                                        style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            _restaurant.discount != null
                                ? Container(
                                    width: context.width,
                                    margin: EdgeInsets.only(
                                        bottom: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        color: Theme.of(context).primaryColor),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _restaurant.discount.discountType ==
                                                    'percent'
                                                ? '${_restaurant.discount.discount}% ${'off'.tr}'
                                                : '${PriceConverter.convertPrice(_restaurant.discount.discount)} ${'off'.tr}',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                          Text(
                                            _restaurant.discount.discountType ==
                                                    'percent'
                                                ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                                : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                                    ' ${'off_on_all_categories'.tr}',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                          SizedBox(
                                              height: (_restaurant.discount
                                                              .minPurchase !=
                                                          0 ||
                                                      _restaurant.discount
                                                              .maxDiscount !=
                                                          0)
                                                  ? 5
                                                  : 0),
                                          _restaurant.discount.minPurchase != 0
                                              ? Text(
                                                  '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_EXTRA_SMALL,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                )
                                              : SizedBox(),
                                          _restaurant.discount.maxDiscount != 0
                                              ? Text(
                                                  '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_EXTRA_SMALL,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                )
                                              : SizedBox(),
                                        ]),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                'Opening Times',
                                style: robotoMedium.copyWith(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            DottedBorder(
                              color: yellowLight,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: [8, 5],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.2),
                                child: Center(
                                  child: OpenTimesView(
                                    restaurant: _restaurant,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                          child: Center(
                              child: Container(
                        width: 1170,
                        decoration:
                            BoxDecoration(color: Theme.of(context).cardColor),
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          labelStyle: robotoBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).primaryColor),
                          tabs: _review
                              ? [
                                  Tab(text: 'all_foods'.tr),
                                  Tab(text: 'reviews'.tr),
                                ]
                              : [
                                  Tab(text: 'all_foods'.tr),
                                ],
                        ),
                      ))),
                    ),
                    SliverToBoxAdapter(
                        child: AnimatedBuilder(
                      animation: _tabController.animation,
                      builder: (context, child) {
                        if (_tabController.index == 0) {
                          return ProductView(
                              scrollController: _scrollController,
                              type: restController.type,
                              onVegFilterTap: (String type) {
                                Get.find<RestaurantController>()
                                    .getProductList('1', type);
                              });
                        } else {
                          return restController.restaurantReviewList != null
                              ? restController.restaurantReviewList.length > 0
                                  ? ListView.builder(
                                      itemCount: restController
                                          .restaurantReviewList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      itemBuilder: (context, index) {
                                        return ReviewWidget(
                                          review: restController
                                              .restaurantReviewList[index],
                                          fromRestaurant: true,
                                          hasDivider: index !=
                                              restController
                                                      .restaurantReviewList
                                                      .length -
                                                  1,
                                        );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: Dimensions.PADDING_SIZE_LARGE),
                                      child: Center(
                                          child: Text('no_review_found'.tr,
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor))),
                                    )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_LARGE),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                        }
                      },
                    )),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
