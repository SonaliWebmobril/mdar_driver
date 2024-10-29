class DocumentListModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  DocumentListModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  DocumentListModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    responseBody = json['ResponseBody'] != null
        ? new ResponseBody.fromJson(json['ResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['succeeded'] = this.succeeded;
    data['ResponseCode'] = this.responseCode;
    data['ResponseMessage'] = this.responseMessage;
    if (this.responseBody != null) {
      data['ResponseBody'] = this.responseBody!.toJson();
    }
    return data;
  }
}

class ResponseBody {
  List<DriverDocuments>? driverDocuments;

  ResponseBody({this.driverDocuments});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    if (json['driverDocuments'] != null) {
      driverDocuments = <DriverDocuments>[];
      json['driverDocuments'].forEach((v) {
        driverDocuments!.add(new DriverDocuments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverDocuments != null) {
      data['driverDocuments'] =
          this.driverDocuments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverDocuments {
  int? verifyStatus;
  String? sId;
  String? driverId;
  String? name;
  String? type;
  String? value;
  String? frontImg;
  String? backImg;
  String? from;
  String? until;
  String? createdAt;
  String? updatedAt;
  int? iV;

  DriverDocuments(
      {this.verifyStatus,
      this.sId,
      this.driverId,
      this.type,
      this.name,
      this.value,
      this.frontImg,
      this.backImg,
      this.from,
      this.until,
      this.createdAt,
      this.updatedAt,
      this.iV});

  DriverDocuments.fromJson(Map<String, dynamic> json) {
    verifyStatus = json['verify_status'];
    sId = json['_id'];
    driverId = json['driver_id'];
    type = json['type'];
    name = json['name'];
    value = json['value'];
    frontImg = json['front_img'];
    backImg = json['back_img'];
    from = json['from'];
    until = json['until'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verify_status'] = this.verifyStatus;
    data['_id'] = this.sId;
    data['driver_id'] = this.driverId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['value'] = this.value;
    data['front_img'] = this.frontImg;
    data['back_img'] = this.backImg;
    data['from'] = this.from;
    data['until'] = this.until;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
