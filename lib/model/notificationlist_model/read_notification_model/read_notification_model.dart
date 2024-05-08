class ReadNotificationModel {
  int? notificationId;

  ReadNotificationModel({this.notificationId});

  ReadNotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    return data;
  }
}
