class BookingInfo {
  double? tax;
  String? nightTimeStart;
  String? nightTimeEnd;
  String? currencyCode;
  String? currencySymbol;
  int? currencyPosition;
  VehicleInfo? vehicleInfo;
  BookingData? bookingData;

  BookingInfo(
      {this.tax,
      this.nightTimeStart,
      this.nightTimeEnd,
      this.currencyCode,
      this.currencySymbol,
      this.currencyPosition,
      this.vehicleInfo,
      this.bookingData});

  BookingInfo.fromJson(Map<String, dynamic> json) {
    tax = double.parse(json['tax'].toString());
    nightTimeStart = json['night_time_start'];
    nightTimeEnd = json['night_time_end'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyPosition = json['currency_position'];
    vehicleInfo = json['vehicleInfo'] != null
        ? new VehicleInfo.fromJson(json['vehicleInfo'])
        : null;
    bookingData = json['bookingData'] != null
        ? new BookingData.fromJson(json['bookingData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax'] = this.tax;
    data['night_time_start'] = this.nightTimeStart;
    data['night_time_end'] = this.nightTimeEnd;
    data['currency_code'] = this.currencyCode;
    data['currency_symbol'] = this.currencySymbol;
    data['currency_position'] = this.currencyPosition;
    if (this.vehicleInfo != null) {
      data['vehicleInfo'] = this.vehicleInfo!.toJson();
    }
    if (this.bookingData != null) {
      data['bookingData'] = this.bookingData!.toJson();
    }
    return data;
  }
}

class VehicleInfo {
  String? img1;
  String? sId;
  String? type;
  String? img;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? basePrice;
  String? country;
  String? noOfPassengers;
  String? nightBasePrice;
  String? nightPerMin;
  String? nightPrice;
  String? nightTimeEnd;
  String? nightTimeStart;
  String? pricePerMin;

  VehicleInfo(
      {this.img1,
      this.sId,
      this.type,
      this.img,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.basePrice,
      this.country,
      this.noOfPassengers,
      this.nightBasePrice,
      this.nightPerMin,
      this.nightPrice,
      this.nightTimeEnd,
      this.nightTimeStart,
      this.pricePerMin});

  VehicleInfo.fromJson(Map<String, dynamic> json) {
    img1 = json['img1'];
    sId = json['_id'];
    type = json['type'];
    img = json['img'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    basePrice = json['base_price'];
    country = json['country'];
    noOfPassengers = json['no_of_passengers'];
    nightBasePrice = json['night_base_price'];
    nightPerMin = json['night_per_min'];
    nightPrice = json['night_price'];
    nightTimeEnd = json['night_time_end'];
    nightTimeStart = json['night_time_start'];
    pricePerMin = json['price_per_min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img1'] = this.img1;
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['img'] = this.img;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    data['base_price'] = this.basePrice;
    data['country'] = this.country;
    data['no_of_passengers'] = this.noOfPassengers;
    data['night_base_price'] = this.nightBasePrice;
    data['night_per_min'] = this.nightPerMin;
    data['night_price'] = this.nightPrice;
    data['night_time_end'] = this.nightTimeEnd;
    data['night_time_start'] = this.nightTimeStart;
    data['price_per_min'] = this.pricePerMin;
    return data;
  }
}

class BookingData {
  String? userId;
  String? driverId;
  String? bookingId;
  String? name;
  String? mobile;
  String? profilePic;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  String? taxiPrice;
  String? km;
  String? totalPrice;
  String? time;
  int? status;
  int? rideType;
  double? pickupLong;
  double? pickupLat;
  double? dropLong;
  double? dropLat;
  int? packageStatus;
  int? waitUser;

  BookingData(
      {this.userId,
      this.driverId,
      this.bookingId,
      this.name,
      this.mobile,
      this.profilePic,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.taxiPrice,
      this.km,
      this.totalPrice,
      this.time,
      this.status,
      this.rideType,
      this.pickupLong,
      this.pickupLat,
      this.dropLong,
      this.dropLat,
      this.packageStatus,
      this.waitUser});

  BookingData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    driverId = json['driver_id'];
    bookingId = json['booking_id'];
    name = json['name'];
    mobile = json['mobile'];
    profilePic = json['profile_pic'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    taxiPrice = json['taxi_price'];
    km = json['km'];
    totalPrice = json['total_price'];
    time = json['time'];
    status = json['status'];
    rideType = json['ride_type'];
    pickupLong = double.parse(json['pickup_long'].toString());
    pickupLat = double.parse(json['pickup_lat'].toString());
    dropLong = double.parse(json['drop_long'].toString());
    dropLat = double.parse(json['drop_lat'].toString());
    packageStatus = json['package_status'];
    waitUser = json['wait_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['driver_id'] = this.driverId;
    data['booking_id'] = this.bookingId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['profile_pic'] = this.profilePic;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['taxi_type'] = this.taxiType;
    data['taxi_price'] = this.taxiPrice;
    data['km'] = this.km;
    data['total_price'] = this.totalPrice;
    data['time'] = this.time;
    data['status'] = this.status;
    data['ride_type'] = this.rideType;
    data['pickup_long'] = this.pickupLong;
    data['pickup_lat'] = this.pickupLat;
    data['drop_long'] = this.dropLong;
    data['drop_lat'] = this.dropLat;
    data['package_status'] = this.packageStatus;
    data['wait_user'] = this.waitUser;
    return data;
  }
}
