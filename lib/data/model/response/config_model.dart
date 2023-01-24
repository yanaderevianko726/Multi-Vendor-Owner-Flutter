class ConfigModel {
  String businessName;
  String logo;
  String address;
  String phone;
  String email;
  BaseUrls baseUrls;
  String currencySymbol;
  bool cashOnDelivery;
  bool digitalPayment;
  String termsAndConditions;
  String privacyPolicy;
  String aboutUs;
  String country;
  DefaultLocation defaultLocation;
  String appUrl;
  bool customerVerification;
  bool orderDeliveryVerification;
  String currencySymbolDirection;
  int appMinimumVersion;
  double perKmShippingCharge;
  double minimumShippingCharge;
  bool demo;
  bool scheduleOrder;
  String orderConfirmationModel;
  bool showDmEarning;
  bool canceledByDeliveryman;
  bool canceledByRestaurant;
  String timeformat;
  bool toggleVegNonVeg;
  bool toggleDmRegistration;
  bool toggleRestaurantRegistration;
  bool maintenanceMode;
  String appUrlAndroid;
  String appUrlIos;
  List<Language> language;
  int scheduleOrderSlotDuration;
  int digitAfterDecimalPoint;

  ConfigModel(
      {this.businessName,
        this.logo,
        this.address,
        this.phone,
        this.email,
        this.baseUrls,
        this.currencySymbol,
        this.cashOnDelivery,
        this.digitalPayment,
        this.termsAndConditions,
        this.privacyPolicy,
        this.aboutUs,
        this.country,
        this.defaultLocation,
        this.appUrl,
        this.customerVerification,
        this.orderDeliveryVerification,
        this.currencySymbolDirection,
        this.appMinimumVersion,
        this.perKmShippingCharge,
        this.minimumShippingCharge,
        this.demo,
        this.scheduleOrder,
        this.orderConfirmationModel,
        this.showDmEarning,
        this.canceledByDeliveryman,
        this.canceledByRestaurant,
        this.timeformat,
        this.toggleVegNonVeg,
        this.toggleDmRegistration,
        this.toggleRestaurantRegistration,
        this.maintenanceMode,
        this.appUrlAndroid,
        this.appUrlIos,
        this.language,
        this.scheduleOrderSlotDuration,
        this.digitAfterDecimalPoint,
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    baseUrls = json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;
    currencySymbol = json['currency_symbol'];
    cashOnDelivery = json['cash_on_delivery'];
    digitalPayment = json['digital_payment'];
    termsAndConditions = json['terms_and_conditions'];
    privacyPolicy = json['privacy_policy'];
    aboutUs = json['about_us'];
    country = json['country'];
    defaultLocation = json['default_location'] != null ? DefaultLocation.fromJson(json['default_location']) : null;
    appUrl = json['app_url'];
    customerVerification = json['customer_verification'];
    orderDeliveryVerification = json['order_delivery_verification'];
    currencySymbolDirection = json['currency_symbol_direction'];
    appMinimumVersion = json['app_minimum_version'];
    perKmShippingCharge = json['per_km_shipping_charge'].toDouble();
    minimumShippingCharge = json['minimum_shipping_charge'].toDouble();
    demo = json['demo'];
    scheduleOrder = json['schedule_order'];
    orderConfirmationModel = json['order_confirmation_model'];
    showDmEarning = json['show_dm_earning'];
    canceledByDeliveryman = json['canceled_by_deliveryman'];
    canceledByRestaurant = json['canceled_by_restaurant'];
    timeformat = json['timeformat'];
    toggleVegNonVeg = json['toggle_veg_non_veg'];
    toggleDmRegistration = json['toggle_dm_registration'];
    toggleRestaurantRegistration = json['toggle_restaurant_registration'];
    maintenanceMode = json['maintenance_mode'];
    appUrlAndroid = json['app_url_android'];
    appUrlIos = json['app_url_ios'];
    if (json['language'] != null) {
      language = [];
      json['language'].forEach((v) {
        language.add(new Language.fromJson(v));
      });
    }
    scheduleOrderSlotDuration = json['schedule_order_slot_duration'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    if (this.baseUrls != null) {
      data['base_urls'] = this.baseUrls.toJson();
    }
    data['currency_symbol'] = this.currencySymbol;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['digital_payment'] = this.digitalPayment;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    data['country'] = this.country;
    if (this.defaultLocation != null) {
      data['default_location'] = this.defaultLocation.toJson();
    }
    data['app_url'] = this.appUrl;
    data['customer_verification'] = this.customerVerification;
    data['order_delivery_verification'] = this.orderDeliveryVerification;
    data['currency_symbol_direction'] = this.currencySymbolDirection;
    data['app_minimum_version'] = this.appMinimumVersion;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['demo'] = this.demo;
    data['schedule_order'] = this.scheduleOrder;
    data['order_confirmation_model'] = this.orderConfirmationModel;
    data['show_dm_earning'] = this.showDmEarning;
    data['canceled_by_deliveryman'] = this.canceledByDeliveryman;
    data['canceled_by_restaurant'] = this.canceledByRestaurant;
    data['timeformat'] = this.timeformat;
    data['toggle_veg_non_veg'] = this.toggleVegNonVeg;
    data['toggle_dm_registration'] = this.toggleDmRegistration;
    data['toggle_restaurant_registration'] = this.toggleRestaurantRegistration;
    data['maintenance_mode'] = this.maintenanceMode;
    data['app_url_android'] = this.appUrlAndroid;
    data['app_url_ios'] = this.appUrlIos;
    if (this.language != null) {
      data['language'] = this.language.map((v) => v.toJson()).toList();
    }
    data['schedule_order_slot_duration'] = this.scheduleOrderSlotDuration;
    data['digit_after_decimal_point'] = this.digitAfterDecimalPoint;
    return data;
  }
}

class BaseUrls {
  String productImageUrl;
  String customerImageUrl;
  String bannerImageUrl;
  String categoryImageUrl;
  String reviewImageUrl;
  String notificationImageUrl;
  String restaurantImageUrl;
  String vendorImageUrl;
  String restaurantCoverPhotoUrl;
  String deliveryManImageUrl;
  String chatImageUrl;
  String campaignImageUrl;
  String businessLogoUrl;

  BaseUrls(
      {this.productImageUrl,
        this.customerImageUrl,
        this.bannerImageUrl,
        this.categoryImageUrl,
        this.reviewImageUrl,
        this.notificationImageUrl,
        this.restaurantImageUrl,
        this.vendorImageUrl,
        this.restaurantCoverPhotoUrl,
        this.deliveryManImageUrl,
        this.chatImageUrl,
        this.campaignImageUrl,
        this.businessLogoUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    productImageUrl = json['product_image_url'];
    customerImageUrl = json['customer_image_url'];
    bannerImageUrl = json['banner_image_url'];
    categoryImageUrl = json['category_image_url'];
    reviewImageUrl = json['review_image_url'];
    notificationImageUrl = json['notification_image_url'];
    restaurantImageUrl = json['restaurant_image_url'];
    vendorImageUrl = json['vendor_image_url'];
    restaurantCoverPhotoUrl = json['restaurant_cover_photo_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    chatImageUrl = json['chat_image_url'];
    campaignImageUrl = json['campaign_image_url'];
    businessLogoUrl = json['business_logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this.productImageUrl;
    data['customer_image_url'] = this.customerImageUrl;
    data['banner_image_url'] = this.bannerImageUrl;
    data['category_image_url'] = this.categoryImageUrl;
    data['review_image_url'] = this.reviewImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['restaurant_image_url'] = this.restaurantImageUrl;
    data['vendor_image_url'] = this.vendorImageUrl;
    data['restaurant_cover_photo_url'] = this.restaurantCoverPhotoUrl;
    data['delivery_man_image_url'] = this.deliveryManImageUrl;
    data['chat_image_url'] = this.chatImageUrl;
    data['campaign_image_url'] = this.campaignImageUrl;
    data['business_logo_url'] = this.businessLogoUrl;
    return data;
  }
}

class DefaultLocation {
  String lat;
  String lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Language {
  String key;
  String value;

  Language({this.key, this.value});

  Language.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
