import 'package:helpers/helpers/print.dart';

class PhoneVerificationResponseModel {
  bool? success;
  Data? data;
  String? message;

  PhoneVerificationResponseModel({this.success, this.data, this.message});

  PhoneVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    try {
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    } catch (err) {
      printRed("Correct this response");
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? error;

  Data({this.error});

  Data.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}
