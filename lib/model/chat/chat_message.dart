class ChatMsgData {
  bool? isReadByreceiver;
  String? msg;
  String? id;
  String? msgType;

  ///firebase-user-id; don't treat it like server-user-id
  String? senderId;

  ///firebase-user-id;don't treat it like server-user-id
  String? receiverId;
  String? sentAt;

  ChatMsgData(
      {this.isReadByreceiver,
      this.msg,
      this.msgType,
      this.senderId,
      this.receiverId,
      this.id,
      this.sentAt});

  ChatMsgData.fromJson(Map<String, dynamic> json) {
    isReadByreceiver = json['isReadByreceiver'];
    msg = json['msg'];
    msgType = json['msg_type'];
    senderId = json['senderId'];
    id = json['id'];
    receiverId = json['receiverId'];
    sentAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isReadByreceiver'] = this.isReadByreceiver;
    data['msg'] = this.msg;
    data['msg_type'] = this.msgType;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['sentAt'] = this.sentAt;
    data['id'] = this.id;
    return data;
  }
}
