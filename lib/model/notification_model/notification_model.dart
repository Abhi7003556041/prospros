class NotificationModel {
  String? notificationType;
  String? pushNotification;
  String? smsNotification;
  bool? isPushNotification;

  NotificationModel(
      {this.notificationType,
      this.pushNotification,
      this.smsNotification,
      this.isPushNotification = true});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    if (isPushNotification!) {
      pushNotification = json['push_notification'];
    } else {
      smsNotification = json['sms_notification'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_type'] = this.notificationType;
    if (isPushNotification!) {
      data['push_notification'] = this.pushNotification;
    } else {
      data['sms_notification'] = this.smsNotification;
    }

    return data;
  }
}
