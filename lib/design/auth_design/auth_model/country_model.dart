class CountryModel {
  bool? succeeded;
  int? responseCode;
  String? responseMessage;
  ResponseBody? responseBody;

  CountryModel(
      {this.succeeded,
      this.responseCode,
      this.responseMessage,
      this.responseBody});

  CountryModel.fromJson(Map<String, dynamic> json) {
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
  List<ListData>? list;

  ResponseBody({this.list});

  ResponseBody.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  String? sId;
  String? name;
  String? iso2;
  String? iso3;
  String? currencyName;
  String? currencyCode;
  String? createdAt;
  String? dialingCode;
  String? updatedAt;
  int? iV;
  String? nightTimeEnd;
  String? nightTimeStart;
  double? tax;
  String? currencySymbol;
  int? currencyPosition;

  ListData(
      {this.sId,
      this.name,
      this.iso2,
      this.iso3,
      this.currencyName,
      this.currencyCode,
      this.createdAt,
      this.dialingCode,
      this.updatedAt,
      this.iV,
      this.nightTimeEnd,
      this.nightTimeStart,
      this.tax,
      this.currencySymbol,
      this.currencyPosition});

  ListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    currencyName = json['currency_name'];
    currencyCode = json['currency_code'];
    createdAt = json['created_at'];
    dialingCode = json['dialing_code'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    nightTimeEnd = json['night_time_end'];
    nightTimeStart = json['night_time_start'];
    tax = double.parse(json['tax'].toString());
    currencySymbol = json['currency_symbol'];
    currencyPosition = json['currency_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['iso2'] = iso2;
    data['iso3'] = iso3;
    data['currency_name'] = currencyName;
    data['currency_code'] = currencyCode;
    data['created_at'] = createdAt;
    data['dialing_code'] = dialingCode;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    data['night_time_end'] = nightTimeEnd;
    data['night_time_start'] = nightTimeStart;
    data['tax'] = tax;
    data['currency_symbol'] = currencySymbol;
    data['currency_position'] = currencyPosition;
    return data;
  }
}
