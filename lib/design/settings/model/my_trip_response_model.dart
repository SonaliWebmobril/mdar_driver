class MyTripResponseModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  MyTripResponseModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  MyTripResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<BookingList>? bookingList;

  ResponseBody({this.bookingList});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    if (json['booking_list'] != null) {
      bookingList = <BookingList>[];
      json['booking_list'].forEach((v) {
        bookingList!.add(BookingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingList != null) {
      data['booking_list'] = bookingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingList {
  String? sId;
  String? userId;
  String? pickupAddress;
  String? dropAddress;
  String? rideType;
  String? taxiType;
  String? totalPrice;
  int? status;
  int? rideStatus;
  String? paymentMethod;
  String? paymentMode;
  String? transactionId;
  String? rating;
  String? createdAt;
  String? taxiImg;
  bool? isCancelSelected;
  String? scheduledDate;
  String? scheduledTime;
  String? currencyPosition;
  String? currencySymbol;

  BookingList(
      {this.sId,
      this.userId,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.totalPrice,
      this.status,
      this.rideStatus,
      this.paymentMethod,
      this.paymentMode,
      this.transactionId,
      this.rating,
      this.createdAt,
      this.taxiImg,
      this.rideType,
      this.isCancelSelected,
      this.scheduledDate,
      this.scheduledTime,
      this.currencyPosition,
      this.currencySymbol});

  BookingList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    totalPrice = json['total_price'];
    rideType = json['ride_type'].toString();
    status = json['status'];
    rideStatus = json['ride_status'];
    paymentMethod = json['payment_method'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    rating = json['rating'];
    createdAt = json['created_at'];
    taxiImg = json['taxi_img'];
    scheduledDate = json['scheduled_date'];
    scheduledTime = json['scheduled_time'];
    currencyPosition = json['currency_position'];
    currencySymbol = json['currency_symbol'];
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
    data['ride_status'] = rideStatus;
    data['ride_type'] = rideType;
    data['payment_method'] = paymentMethod;
    data['payment_mode'] = paymentMode;
    data['transaction_id'] = transactionId;
    data['rating'] = rating;
    data['created_at'] = createdAt;
    data['taxi_img'] = taxiImg;
    data['scheduled_date'] = scheduledDate;
    data['scheduled_time'] = scheduledTime;

    data['currency_position'] = currencyPosition;
    data['currency_symbol'] = currencySymbol;

    return data;
  }
}

class MyTripRequestModel {
  String? page;
  String? recode;
  String? rideType;

  MyTripRequestModel({this.page, this.recode, this.rideType});

  MyTripRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    recode = json['recode'];
    rideType = json['ride_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['recode'] = recode;
    data['ride_type'] = rideType;
    return data;
  }
}
