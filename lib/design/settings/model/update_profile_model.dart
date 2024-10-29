//****************** request model ************/

class UpdateProfileRequestModel {
  String? name;
  String? email;
  String? gender;
  String? rideType;

  UpdateProfileRequestModel({this.name, this.email, this.gender,this.rideType});

  UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    rideType = json['ride_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['gender'] = gender;
    data['ride_type'] = rideType;
    return data;
  }
}

//************* reponse model ********************/

class UpdateProfileResponseModel {
  int? responseCode;
  String? responseMessage;
  bool? succeeded;
  ProfileUpdate? profileUpdate;

  UpdateProfileResponseModel(
      {this.responseCode,
      this.responseMessage,
      this.succeeded,
      this.profileUpdate});

  UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    succeeded = json['succeeded'];
    profileUpdate = json['ResponseBody'] != null
        ? ProfileUpdate.fromJson(json['ResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    data['succeeded'] = succeeded;
    if (profileUpdate != null) {
      data['ResponseBody'] = profileUpdate!.toJson();
    }
    return data;
  }
}

class ProfileUpdate {
  bool? acknowledged;
  int? modifiedCount;
  int? upsertedId;
  int? upsertedCount;
  int? matchedCount;
  String? profilePic;

  ProfileUpdate(
      {this.acknowledged,
      this.modifiedCount,
      this.upsertedId,
      this.upsertedCount,
      this.matchedCount,
      this.profilePic});

  ProfileUpdate.fromJson(Map<String, dynamic> json) {
    acknowledged = json['acknowledged'];
    modifiedCount = json['modifiedCount'];
    upsertedId = json['upsertedId'];
    upsertedCount = json['upsertedCount'];
    matchedCount = json['matchedCount'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acknowledged'] = acknowledged;
    data['modifiedCount'] = modifiedCount;
    data['upsertedId'] = upsertedId;
    data['upsertedCount'] = upsertedCount;
    data['matchedCount'] = matchedCount;
    data['profile_pic'] = profilePic;
    return data;
  }
}
