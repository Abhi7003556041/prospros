class NotificationListResponseModel {
  bool? success;
  List<Data>? data;
  String? message;

  NotificationListResponseModel({this.success, this.data, this.message});

  NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? senderId;
  int? receiverId;
  String? type;
  String? message;
  String? readAt;
  String? datetime;

  Data(
      {this.id,
      this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.datetime,
      this.readAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    datetime = json['dateTime'];
    type = json['type'];
    message = json['message'];
    readAt = json['read_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['type'] = this.type;
    data['message'] = this.message;
    data['read_at'] = this.readAt;
    data['dateTime'] = this.datetime;
    return data;
  }
}
