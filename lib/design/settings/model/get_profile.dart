class GetProfileResponseModel {
  int? responseCode;
  String? responseMessage;
  bool? succeeded;
  ResponseBody? responseBody;

  GetProfileResponseModel(
      {this.responseCode,
      this.responseMessage,
      this.succeeded,
      this.responseBody});

  GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    succeeded = json['succeeded'];
    responseBody = json['ResponseBody'] != null
        ? ResponseBody.fromJson(json['ResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    data['succeeded'] = succeeded;
    if (responseBody != null) {
      data['ResponseBody'] = responseBody!.toJson();
    }
    return data;
  }
}

class ResponseBody {
  String? sId;
  String? mobile;
  String? gender;
  int? criminalRecord;
  String? countryCode;
  String? userType;
  String? rideType;
  String? languageId;
  String? status;
  String? profilePic;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? email;
  String? name;
  String? avgRating;
  String? currencyCode;
  String? currencySymbol;
  int? currencyPosition;
  String? NightTimeStart;
  String? NightTineEnd;
  double? tax;

  ResponseBody({
    this.sId,
    this.mobile,
    this.gender,
    this.criminalRecord,
    this.countryCode,
    this.userType,
    this.languageId,
    this.status,
    this.profilePic,
    this.deviceToken,
    this.rideType,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.email,
    this.name,
    this.avgRating,
    this.currencyCode,
    this.currencySymbol,
    this.currencyPosition,
    this.NightTimeStart,
    this.NightTineEnd,
    this.tax,
  });

  ResponseBody.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    gender = json['gender'];
    criminalRecord = json['criminal_record'];
    countryCode = json['country_code'];
    userType = json['user_type'];
    languageId = json['language_id'];
    status = json['status'];
    profilePic = json['profile_pic'];
    rideType = json['ride_type'].toString();
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    email = json['email'];
    name = json['name'];
    avgRating = json['avgRating'];
    tax = double.parse(json['tax'].toString());
    NightTimeStart = json['night_time_start'];
    NightTineEnd = json['night_time_end'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyPosition = json['currency_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['criminal_record'] = criminalRecord;
    data['country_code'] = countryCode;
    data['user_type'] = userType;
    data['ride_type'] = rideType;
    data['language_id'] = languageId;
    data['status'] = status;
    data['profile_pic'] = profilePic;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    data['email'] = email;
    data['name'] = name;
    data['avgRating'] = avgRating;
    data['tax'] = tax;
    data['night_time_start'] = NightTimeStart;
    data['night_time_end'] = NightTineEnd;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_position'] = currencyPosition;
    return data;
  }
}
