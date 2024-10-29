class WaitingBookingList {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  WaitingBookingList(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  WaitingBookingList.fromJson(Map<String, dynamic> json) {
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
  List<BookingInfoList>? bookingInfoList;

  ResponseBody({this.bookingInfoList});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    if (json['bookingInfoList'] != null) {
      bookingInfoList = <BookingInfoList>[];
      json['bookingInfoList'].forEach((v) {
        bookingInfoList!.add(BookingInfoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingInfoList != null) {
      data['bookingInfoList'] =
          bookingInfoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingInfoList {
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
  String? rideType;
  double? pickupLong;
  int? packageStatus;
  double? pickupLat;
  double? dropLong;
  double? dropLat;
  String? driverId;
  String? userId;

  BookingInfoList(
      {this.bookingId,
      this.name,
      this.mobile,
      this.profilePic,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.taxiPrice,
      this.km,
      this.packageStatus,
      this.totalPrice,
      this.time,
      this.status,
      this.pickupLong,
      this.pickupLat,
      this.dropLong,
      this.dropLat,
      this.driverId,
      this.userId});

  BookingInfoList.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    name = json['name'];
    mobile = json['mobile'];
    rideType = json['ride_type'].toString();
    profilePic = json['profile_pic'];
    packageStatus = json['package_status'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    taxiPrice = json['taxi_price'];
    km = json['km'];
    totalPrice = json['total_price'];
    time = json['time'];
    status = json['status'];
    pickupLong = json['pickup_long'];
    pickupLat = json['pickup_lat'];
    dropLong = double.parse(json['drop_long'].toString());
    dropLat = double.parse(json['drop_lat'].toString());
    driverId = json['driver_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['package_status'] = packageStatus;
    data['ride_type'] = rideType;
    data['profile_pic'] = profilePic;
    data['pickup_address'] = pickupAddress;
    data['drop_address'] = dropAddress;
    data['taxi_type'] = taxiType;
    data['taxi_price'] = taxiPrice;
    data['km'] = km;
    data['total_price'] = totalPrice;
    data['time'] = time;
    data['status'] = status;
    data['pickup_long'] = pickupLong;
    data['pickup_lat'] = pickupLat;
    data['drop_long'] = dropLong;
    data['drop_lat'] = dropLat;
    data['driver_id'] = driverId;
    data['user_id'] = userId;
    return data;
  }
}
