class MediaUpload {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  MediaUpload(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  MediaUpload.fromJson(Map<String, dynamic> json) {
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
  String? mediaUrl;

  ResponseBody({this.mediaUrl});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    mediaUrl = json['mediaUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaUrl'] = this.mediaUrl;
    return data;
  }
}