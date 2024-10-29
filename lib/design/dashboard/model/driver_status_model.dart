//************ REquest model ******************/
class DriverStatusRequestModel {
  String? onlineStatus;

  DriverStatusRequestModel({this.onlineStatus});

  DriverStatusRequestModel.fromJson(Map<String, dynamic> json) {
    onlineStatus = json['online_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['online_status'] = onlineStatus;
    return data;
  }
}

//************* response model *************/

class DriverStatusResponseModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  DriverStatusResponseModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  DriverStatusResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? onlineStatus;

  ResponseBody({this.onlineStatus});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    onlineStatus = json['online_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['online_status'] = onlineStatus;
    return data;
  }
}
