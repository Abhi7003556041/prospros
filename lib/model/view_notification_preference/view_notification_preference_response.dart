class ViewNotificationPreferenceResponse {
  bool? success;
  List<Data>? data;
  String? message;

  ViewNotificationPreferenceResponse({this.success, this.data, this.message});

  ViewNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? notificationType;
  String? pushNotification;
  String? smsNotification;

  Data(
      {this.id,
      this.notificationType,
      this.pushNotification,
      this.smsNotification});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationType = json['notification_type'];
    pushNotification = json['push_notification'];
    smsNotification = json['sms_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification_type'] = this.notificationType;
    data['push_notification'] = this.pushNotification;
    data['sms_notification'] = this.smsNotification;

    return data;
  }
}
