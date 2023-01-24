import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/body/bank_info_body.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BankRepo {
  final ApiClient apiClient;
  BankRepo({@required this.apiClient});
  
  Future<Response> updateBankInfo(BankInfoBody bankInfoBody) async {
    return await apiClient.putData(AppConstants.UPDATE_BANK_INFO_URI, bankInfoBody.toJson());
  }

  Future<Response> getWithdrawList() async {
    return await apiClient.getData(AppConstants.WITHDRAW_LIST_URI);
  }

  Future<Response> requestWithdraw(String amount) async {
    return await apiClient.postData(AppConstants.WITHDRAW_REQUEST_URI, {'amount': amount});
  }

}