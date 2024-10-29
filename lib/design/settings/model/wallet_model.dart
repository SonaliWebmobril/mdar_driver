class WalletModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  WalletModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  WalletModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    responseBody = json['ResponseBody'] != null
        ? ResponseBody.fromJson(json['ResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    if (responseBody != null) {
      data['ResponseBody'] = responseBody!.toJson();
    }
    return data;
  }
}

class ResponseBody {
  String? totalPayment;
  String? credit;
  String? debit;
  List<Data>? list;

  ResponseBody(this.totalPayment, this.credit, this.debit, this.list);

  ResponseBody.fromJson(Map<String, dynamic> json) {
    totalPayment = json['totalPayment'].toString();
    credit = json['credit'].toString();
    debit = json['debit'].toString();
    if (json['list'] != null) {
      list = <Data>[];
      json['list'].forEach((v) {
        list!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? driverId;
  String? amount;
  String? paymentType;
  String? requestType;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? originalAmount;

  Data(
      {this.sId,
      this.driverId,
      this.amount,
      this.paymentType,
      this.requestType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.originalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    driverId = json['driver_id'].toString();
    amount = json['amount'].toString();
    paymentType = json['payment_type'].toString();
    requestType = json['request_type'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    originalAmount = json['original_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['driver_id'] = driverId;
    data['amount'] = amount;
    data['payment_type'] = paymentType;
    data['request_type'] = requestType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['original_amount'] = originalAmount;

    return data;
  }
}
