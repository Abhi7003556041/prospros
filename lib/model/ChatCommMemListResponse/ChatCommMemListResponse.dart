class ChatCommMemListResponse {
  bool? success;
  List<Data>? data;
  String? message;

  ChatCommMemListResponse({this.success, this.data, this.message});

  ChatCommMemListResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? name;
  String? type;
  String? roomId;
  int? unreadMsgCount;
  String? message;
  String? profileImg;
  String? messageTime;
  bool? activeStatus;

  Data(
      {this.id,
      this.userId,
      this.name,
      this.type,
      this.roomId,
      this.unreadMsgCount,
      this.message,
      this.activeStatus,
      this.messageTime,
      this.profileImg});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    type = json['type'];
    roomId = json['room_id'];
    unreadMsgCount = json['unread_msg_count'];
    message = json['message'];
    profileImg = json['profile_image'];
    messageTime = json['msg_time'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['room_id'] = this.roomId;
    data['unread_msg_count'] = this.unreadMsgCount;
    data['message'] = this.message;
    data['profile_image'] = this.profileImg;
    data['msg_time'] = this.messageTime;
    data['active_status'] = this.activeStatus;
    return data;
  }
}
