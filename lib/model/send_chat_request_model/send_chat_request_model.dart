class SendChatRequestResponseModel {
  bool? success;
  Data? data;
  String? message;

  SendChatRequestResponseModel({this.success, this.data, this.message});

  SendChatRequestResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  int? sendRequestId;
  int? receiveRequestId;
  String? roomId;
  String? isAccept;

  Data(
      {this.id,
      this.sendRequestId,
      this.receiveRequestId,
      this.roomId,
      this.isAccept});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sendRequestId = json['send_request_id'];
    receiveRequestId = json['receive_request_id'];
    roomId = json['room_id'];
    isAccept = json['is_accept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['send_request_id'] = this.sendRequestId;
    data['receive_request_id'] = this.receiveRequestId;
    data['room_id'] = this.roomId;
    data['is_accept'] = this.isAccept;
    return data;
  }
}
