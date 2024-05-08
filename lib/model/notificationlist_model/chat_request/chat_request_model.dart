class ChatRequestModel {
  int? receiverId;
  int? senderId;
  String? isAccept;

  ChatRequestModel({this.receiverId, this.isAccept, this.senderId});

  ChatRequestModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    isAccept = json['is_accept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver_id'] = this.receiverId;
    data['is_accept'] = this.isAccept;
    data['sender_id'] = this.senderId;
    return data;
  }
}
