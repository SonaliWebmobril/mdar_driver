class RequestModelVerifyOtp {
  String? country;
  String? otp;

  RequestModelVerifyOtp({this.otp, this.country});

  RequestModelVerifyOtp.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['country'] = country;
    return data;
  }
}

class ResponseModelVerifyOtp {
  int? responseCode;
  String? responseMessage;
  bool? succeeded;
  VarifyOtp? varifyOtp;

  ResponseModelVerifyOtp(
      {this.responseCode,
      this.responseMessage,
      this.succeeded,
      this.varifyOtp});

  ResponseModelVerifyOtp.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    succeeded = json['succeeded'];
    varifyOtp = json['varifyOtp'] != null
        ? VarifyOtp.fromJson(json['varifyOtp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    data['succeeded'] = succeeded;
    if (varifyOtp != null) {
      data['varifyOtp'] = varifyOtp!.toJson();
    }
    return data;
  }
}

class VarifyOtp {
  String? id;
  String? mobile;
  String? loginToken;
  String? status;
  int? documentStatus;
  int? isVerify;
  String? SecurityDeposit;
  String? currencyCode;
  String? currencySymbol;
  int? currencyPosition;
  String? NightTimeStart;
  String? NightTineEnd;
  double? tax;
  String? email;

  // double? avgRating;

  VarifyOtp(
      {this.id,
      this.mobile,
      this.loginToken,
      this.status,
      this.documentStatus,
      this.isVerify,
      this.SecurityDeposit,
      this.currencyCode,
      this.currencySymbol,
      this.currencyPosition,
      this.NightTimeStart,
      this.NightTineEnd,
      this.tax,
      this.email});

  VarifyOtp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    loginToken = json['loginToken'];
    status = json['status'];
    documentStatus = json['documentStatus'];
    isVerify = json['is_verify'];
    SecurityDeposit = json['security_deposit_amount'];
    tax = double.parse(json['tax'].toString());
    NightTimeStart = json['night_time_start'];
    NightTineEnd = json['night_time_end'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyPosition = json['currency_position'];
    email = json['email'];
    // avgRating = json['avgRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mobile'] = mobile;
    data['loginToken'] = loginToken;
    data['status'] = status;
    data['documentStatus'] = documentStatus;
    data['is_verify'] = isVerify;
    data['security_deposit_amount'] = SecurityDeposit;
    data['tax'] = tax;
    data['night_time_start'] = NightTimeStart;
    data['night_time_end'] = NightTineEnd;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_position'] = currencyPosition;

    data['email'] = email; // data['avgRating'] = avgRating;
    return data;
  }
}

class ResendOtpResponse {
  int? responseCode;
  String? responseMessage;
  bool? succeeded;
  SendOtp? sendOtp;

  ResendOtpResponse(
      {this.responseCode, this.responseMessage, this.succeeded, this.sendOtp});

  ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    succeeded = json['succeeded'];
    sendOtp =
        json['sendOtp'] != null ? SendOtp.fromJson(json['sendOtp']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    data['succeeded'] = succeeded;
    if (sendOtp != null) {
      data['sendOtp'] = sendOtp!.toJson();
    }
    return data;
  }
}

class SendOtp {
  String? otp;

  SendOtp({this.otp});

  SendOtp.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['otp'] = otp;
    return data;
  }
}
