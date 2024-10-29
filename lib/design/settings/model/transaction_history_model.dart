class TransactionHistoryResponseModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  TransactionHistoryResponseModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
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
  PaymentInfo? paymentInfo;

  ResponseBody({this.paymentInfo});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    paymentInfo = json['payment_info'] != null
        ? PaymentInfo.fromJson(json['payment_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentInfo != null) {
      data['payment_info'] = paymentInfo!.toJson();
    }
    return data;
  }
}

class PaymentInfo {
  double? totalPrice;
  List<Cash>? cash;
  List<Online>? online;

  PaymentInfo({this.totalPrice, this.cash, this.online});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    totalPrice = double.parse(json['total_price'].toString());
    if (json['Cash'] != null) {
      cash = <Cash>[];
      json['Cash'].forEach((v) {
        cash!.add(Cash.fromJson(v));
      });
    }
    if (json['Online'] != null) {
      online = <Online>[];
      json['Online'].forEach((v) {
        online!.add(Online.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_price'] = totalPrice;
    if (cash != null) {
      data['Cash'] = cash!.map((v) => v.toJson()).toList();
    }
    if (online != null) {
      data['Online'] = online!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cash {
  String? sId;
  String? userId;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  String? totalPrice;
  int? status;
  String? rating;
  String? paymentMethod;
  String? paymentMode;
  String? transactionId;
  String? createdAt;
  String? taxiImg;

  Cash(
      {this.sId,
      this.userId,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.totalPrice,
      this.status,
      this.rating,
      this.paymentMethod,
      this.paymentMode,
      this.transactionId,
      this.createdAt,
      this.taxiImg});

  Cash.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    totalPrice = json['total_price'];
    status = json['status'];
    rating = json['rating'];
    paymentMethod = json['payment_method'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    taxiImg = json['taxi_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['pickup_address'] = pickupAddress;
    data['drop_address'] = dropAddress;
    data['taxi_type'] = taxiType;
    data['total_price'] = totalPrice;
    data['status'] = status;
    data['rating'] = rating;
    data['payment_method'] = paymentMethod;
    data['payment_mode'] = paymentMode;
    data['transaction_id'] = transactionId;
    data['created_at'] = createdAt;
    data['taxi_img'] = taxiImg;
    return data;
  }
}

class Online {
  String? sId;
  String? userId;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  String? totalPrice;
  int? status;
  String? rating;
  String? paymentMethod;
  String? paymentMode;
  String? transactionId;
  String? createdAt;
  String? taxiImg;

  Online(
      {this.sId,
      this.userId,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.totalPrice,
      this.status,
      this.rating,
      this.paymentMethod,
      this.paymentMode,
      this.transactionId,
      this.createdAt,
      this.taxiImg});

  Online.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    totalPrice = json['total_price'];
    status = json['status'];
    rating = json['rating'];
    paymentMethod = json['payment_method'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    taxiImg = json['taxi_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['pickup_address'] = pickupAddress;
    data['drop_address'] = dropAddress;
    data['taxi_type'] = taxiType;
    data['total_price'] = totalPrice;
    data['status'] = status;
    data['rating'] = rating;
    data['payment_method'] = paymentMethod;
    data['payment_mode'] = paymentMode;
    data['transaction_id'] = transactionId;
    data['created_at'] = createdAt;
    data['taxi_img'] = taxiImg;
    return data;
  }
}
