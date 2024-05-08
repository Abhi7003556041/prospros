class CountryListModel {
  bool? success;
  List<DataCountryListModel>? data;
  String? message;

  CountryListModel({this.success, this.data, this.message});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataCountryListModel>[];
      json['data'].forEach((v) {
        data!.add(new DataCountryListModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class DataCountryListModel {
  int? id;
  String? shortname;
  String? name;
  int? phonecode;
  String? flag;

  DataCountryListModel(
      {this.id, this.shortname, this.name, this.phonecode, this.flag});

  DataCountryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortname = json['shortname'];
    name = json['name'];
    phonecode = json['phonecode'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shortname'] = this.shortname;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    data['flag'] = this.flag;
    return data;
  }
}
