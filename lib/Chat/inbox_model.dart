class InboxModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  List<ResponseBody>? responseBody;

  InboxModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  InboxModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    if (json['ResponseBody'] != null) {
      responseBody = <ResponseBody>[];
      json['ResponseBody'].forEach((v) {
        responseBody!.add(new ResponseBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['succeeded'] = this.succeeded;
    data['ResponseCode'] = this.responseCode;
    data['ResponseMessage'] = this.responseMessage;
    if (this.responseBody != null) {
      data['ResponseBody'] = this.responseBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseBody {
  String? sId;
  String? senderId;
  String? senderRole;
  String? bookingId;
  String? content;
  String? contentType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? profilePic;

  ResponseBody(
      {this.sId,
      this.senderId,
      this.senderRole,
      this.bookingId,
      this.content,
      this.contentType,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.profilePic});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    senderRole = json['sender_role'];
    bookingId = json['booking_id'];
    content = json['content'];
    contentType = json['content_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sender_id'] = this.senderId;
    data['sender_role'] = this.senderRole;
    data['booking_id'] = this.bookingId;
    data['content'] = this.content;
    data['content_type'] = this.contentType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;

    data['profile_pic'] = this.profilePic;
    return data;
  }
}
