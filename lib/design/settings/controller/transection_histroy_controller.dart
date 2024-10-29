import 'package:get/get.dart';

import '../../../services/api_sevices.dart';
import '../model/transaction_history_model.dart';

class TransactionHistoryController extends GetxController {
  RxBool isLoading = true.obs;
  Rxn<TransactionHistoryResponseModel> transactionHistoryResponseModel = Rxn();
  NetworkServices networkServices = NetworkServices();

  Future<void> doMytripTransactionGetAllRequest() async {
    isLoading.value = true;
    try {
      final response = await networkServices.getMYtripTransactionHistory();
      print("transaction history ...  ${response.responseBody}");
      if (response.responseCode == 200) {
        print("transaction history ...  ${response.responseBody}");
        transactionHistoryResponseModel.value = response;
        isLoading.value = false;
      } else {
        transactionHistoryResponseModel.value = response;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("doMytripTransactionGetAllRequest   ,... $e");
    }
  }
}
