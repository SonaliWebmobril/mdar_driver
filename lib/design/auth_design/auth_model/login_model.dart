class LoginRequestModel {
  String? mobile;
  String? countryCode;
  String? userType;
  String? languageId;
  String? deviceToken;
  String? country;
  double? latitude;
  double? longitude;

  LoginRequestModel(
      {this.mobile,
      this.countryCode,
      this.userType,
      this.languageId,
      this.deviceToken,
      this.country,
      this.latitude,
      this.longitude});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    countryCode = json['country_code'];
    userType = json['user_type'];
    languageId = json['language_id'];
    country = json['country'];
    deviceToken = json['device_token'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['user_type'] = userType;
    data['country'] = country;
    data['language_id'] = languageId;
    data['device_token'] = deviceToken;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class LoginResponseModel {
  int? responseCode;
  String? responseMessage;
  bool? succeeded;
  SendOtp? sendOtp;

  LoginResponseModel(
      {this.responseCode, this.responseMessage, this.succeeded, this.sendOtp});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    succeeded = json['succeeded'];
    sendOtp =
        json['sendOtp'] != null ? SendOtp.fromJson(json['sendOtp']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? token;
  String? otp;

  SendOtp({this.token, this.otp});

  SendOtp.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['otp'] = otp;
    return data;
  }
}
