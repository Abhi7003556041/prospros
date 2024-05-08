class SendChatMessageModel {
  String? roomId;
  int? receiverId;
  String? message;

  SendChatMessageModel({this.roomId, this.receiverId, this.message});

  SendChatMessageModel.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    return data;
  }
}
