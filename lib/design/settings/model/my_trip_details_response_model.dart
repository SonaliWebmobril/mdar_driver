class MyTRipDetailREsponseModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  MyTRipDetailREsponseModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  MyTRipDetailREsponseModel.fromJson(Map<String, dynamic> json) {
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
  BookingDetail? bookingDetail;

  ResponseBody({this.bookingDetail});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['bookingData'] != null
        ? BookingDetail.fromJson(json['bookingData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingDetail != null) {
      data['bookingData'] = bookingDetail!.toJson();
    }
    return data;
  }
}

class BookingDetail {
  String? sId;
  String? userId;
  PickupLocation? pickupLocation;
  String? pickupAddress;
  PickupLocation? dropLocation;
  String? dropAddress;
  String? taxiType;
  String? taxiPrice;
  String? km;
  String? currencyPosition;
  String? currencySymbol;
  String? time;
  String? totalPrice;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? driverId;
  PickupLocation? driverLocation;
  String? otp;
  String? discription;
  String? rating;
  List<UserData>? userData;
  List<DriverData>? driverData;

  BookingDetail(
      {this.sId,
      this.userId,
      this.pickupLocation,
      this.pickupAddress,
      this.dropLocation,
      this.dropAddress,
      this.taxiType,
      this.taxiPrice,
      this.km,
      this.currencyPosition,
      this.currencySymbol,
      this.time,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.driverId,
      this.driverLocation,
      this.otp,
      this.discription,
      this.rating,
      this.userData,
      this.driverData});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    pickupLocation = json['pickup_location'] != null
        ? PickupLocation.fromJson(json['pickup_location'])
        : null;
    pickupAddress = json['pickup_address'];
    dropLocation = json['drop_location'] != null
        ? PickupLocation.fromJson(json['drop_location'])
        : null;
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    taxiPrice = json['taxi_price'];
    km = json['km'];
    time = json['time'];
    currencyPosition = json['currency_position'];
    currencySymbol = json['currency_symbol'];
    totalPrice = json['total_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    driverId = json['driver_id'];
    driverLocation = json['driver_location'] != null
        ? PickupLocation.fromJson(json['driver_location'])
        : null;
    otp = json['otp'];
    discription = json['discription'];
    rating = json['rating'];
    if (json['userData'] != null) {
      userData = <UserData>[];
      json['userData'].forEach((v) {
        userData!.add(UserData.fromJson(v));
      });
    }
    if (json['driverData'] != null) {
      driverData = <DriverData>[];
      json['driverData'].forEach((v) {
        driverData!.add(DriverData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    if (pickupLocation != null) {
      data['pickup_location'] = pickupLocation!.toJson();
    }
    data['pickup_address'] = pickupAddress;
    if (dropLocation != null) {
      data['drop_location'] = dropLocation!.toJson();
    }
    data['drop_address'] = dropAddress;
    data['taxi_type'] = taxiType;
    data['taxi_price'] = taxiPrice;
    data['km'] = km;
    data['time'] = time;
    data['currency_symbol'] = currencySymbol;
    data['currency_position'] = currencyPosition;
    data['total_price'] = totalPrice;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    data['driver_id'] = driverId;
    if (driverLocation != null) {
      data['driver_location'] = driverLocation!.toJson();
    }
    data['otp'] = otp;
    data['discription'] = discription;
    data['rating'] = rating;
    if (userData != null) {
      data['userData'] = userData!.map((v) => v.toJson()).toList();
    }
    if (driverData != null) {
      data['driverData'] = driverData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickupLocation {
  String? type;
  List<dynamic>? coordinates;

  PickupLocation({this.type, this.coordinates});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class UserData {
  String? sId;
  String? mobile;
  String? countryCode;
  String? userType;
  String? languageId;
  String? status;
  String? profilePic;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  int? iV;
  PickupLocation? location;
  String? email;
  String? name;

  UserData(
      {this.sId,
      this.mobile,
      this.countryCode,
      this.userType,
      this.languageId,
      this.status,
      this.profilePic,
      this.deviceToken,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.location,
      this.email,
      this.name});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    userType = json['user_type'];
    languageId = json['language_id'];
    status = json['status'];
    profilePic = json['profile_pic'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    location = json['location'] != null
        ? PickupLocation.fromJson(json['location'])
        : null;
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['user_type'] = userType;
    data['language_id'] = languageId;
    data['status'] = status;
    data['profile_pic'] = profilePic;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}

class DriverData {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? countryCode;
  String? userType;
  String? languageId;
  String? status;
  String? onlineStatus;
  String? profilePic;
  String? deviceToken;
  PickupLocation? location;
  String? createdAt;
  String? updatedAt;
  int? iV;

  DriverData(
      {this.sId,
      this.name,
      this.email,
      this.mobile,
      this.countryCode,
      this.userType,
      this.languageId,
      this.status,
      this.onlineStatus,
      this.profilePic,
      this.deviceToken,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.iV});

  DriverData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    userType = json['user_type'];
    languageId = json['language_id'];
    status = json['status'];
    onlineStatus = json['online_status'];
    profilePic = json['profile_pic'];
    deviceToken = json['device_token'];
    location = json['location'] != null
        ? PickupLocation.fromJson(json['location'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['user_type'] = userType;
    data['language_id'] = languageId;
    data['status'] = status;
    data['online_status'] = onlineStatus;
    data['profile_pic'] = profilePic;
    data['device_token'] = deviceToken;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Location {
  String? type;
  List<dynamic>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
