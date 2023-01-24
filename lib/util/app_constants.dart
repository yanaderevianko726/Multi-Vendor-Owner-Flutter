import 'package:efood_multivendor_restaurant/data/model/response/language_model.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';

class AppConstants {
  static const String APP_NAME = 'SWUSHD Restaurant';
  static const double APP_VERSION = 5.6;

  static const String BASE_URL = 'https://swushd.app';
  static const String CONFIG_URI = '/api/v1/config';
  static const String LOGIN_URI = '/api/v1/auth/vendor/login';
  static const String FORGET_PASSWORD_URI =
      '/api/v1/auth/vendor/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/vendor/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/vendor/reset-password';
  static const String TOKEN_URI = '/api/v1/vendor/update-fcm-token';
  static const String ALL_ORDERS_URI = '/api/v1/vendor/all-orders';
  static const String CURRENT_ORDERS_URI = '/api/v1/vendor/current-orders';
  static const String COMPLETED_ORDERS_URI = '/api/v1/vendor/completed-orders';
  static const String ORDER_DETAILS_URI =
      '/api/v1/vendor/order-details?order_id=';
  static const String UPDATE_ORDER_STATUS_URI =
      '/api/v1/vendor/update-order-status';
  static const String NOTIFICATION_URI = '/api/v1/vendor/notifications';
  static const String PROFILE_URI = '/api/v1/vendor/profile';
  static const String UPDATE_PROFILE_URI = '/api/v1/vendor/update-profile';
  static const String BASIC_CAMPAIGN_URI = '/api/v1/vendor/get-basic-campaigns';
  static const String JOIN_CAMPAIGN_URI = '/api/v1/vendor/campaign-join';
  static const String LEAVE_CAMPAIGN_URI = '/api/v1/vendor/campaign-leave';
  static const String WITHDRAW_LIST_URI = '/api/v1/vendor/get-withdraw-list';
  static const String PRODUCT_LIST_URI = '/api/v1/vendor/get-products-list';
  static const String UPDATE_BANK_INFO_URI = '/api/v1/vendor/update-bank-info';
  static const String WITHDRAW_REQUEST_URI = '/api/v1/vendor/request-withdraw';
  static const String CATEGORY_URI = '/api/v1/categories';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String ADDON_URI = '/api/v1/vendor/addon';
  static const String ADD_ADDON_URI = '/api/v1/vendor/addon/store';
  static const String UPDATE_ADDON_URI = '/api/v1/vendor/addon/update';
  static const String DELETE_ADDON_URI = '/api/v1/vendor/addon/delete';
  static const String ATTRIBUTE_URI = '/api/v1/vendor/attributes';
  static const String RESTAURANT_UPDATE_URI =
      '/api/v1/vendor/update-business-setup';
  static const String ADD_PRODUCT_URI = '/api/v1/vendor/product/store';
  static const String UPDATE_PRODUCT_URI = '/api/v1/vendor/product/update';
  static const String DELETE_PRODUCT_URI = '/api/v1/vendor/product/delete';
  static const String RESTAURANT_REVIEW_URI = '/api/v1/vendor/product/reviews';
  static const String PRODUCT_REVIEW_URI = '/api/v1/products/reviews';
  static const String UPDATE_PRODUCT_STATUS_URI =
      '/api/v1/vendor/product/status';
  static const String UPDATE_RESTAURANT_STATUS_URI =
      '/api/v1/vendor/update-active-status';
  static const String SEARCH_PRODUCT_LIST_URI = '/api/v1/vendor/product/search';
  static const String PLACE_ORDER_URI = '/api/v1/vendor/pos/place-order';
  static const String POS_ORDERS_URI = '/api/v1/vendor/pos/orders';
  static const String SEARCH_CUSTOMERS_URI = '/api/v1/vendor/pos/customers';
  static const String DM_LIST_URI = '/api/v1/vendor/delivery-man/list';
  static const String ADD_DM_URI = '/api/v1/vendor/delivery-man/store';
  static const String UPDATE_DM_URI = '/api/v1/vendor/delivery-man/update/';
  static const String DELETE_DM_URI = '/api/v1/vendor/delivery-man/delete';
  static const String UPDATE_DM_STATUS_URI =
      '/api/v1/vendor/delivery-man/status';
  static const String DM_REVIEW_URI = '/api/v1/vendor/delivery-man/preview';
  static const String ADD_SCHEDULE = '/api/v1/vendor/schedule/store';
  static const String DELETE_SCHEDULE = '/api/v1/vendor/schedule/';

  // Shared Key
  static const String THEME = 'theme';
  static const String INTRO = 'intro';
  static const String TOKEN = 'multivendor_restaurant_token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String NOTIFICATION = 'notification';
  static const String NOTIFICATION_COUNT = 'notification_count';
  static const String SEARCH_HISTORY = 'search_history';
  static const String TOPIC = 'all_zone_restaurant';
  static const String ZONE_TOPIC = 'zone_topic';
  static const String LOCALIZATION_KEY = 'X-localization';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabic,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
