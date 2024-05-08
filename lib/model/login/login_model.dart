class LoginModel {
  String? emailId;
  String? password;

  ///assign fcm token; should be obtained from firebase messaging token
  String? deviceId;

  LoginModel({this.emailId, this.password, this.deviceId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    emailId = json['email'];
    password = json['password'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.emailId;
    data['password'] = this.password;
    data['device_id'] = this.deviceId;
    return data;
  }
}
