class SendChatRequestModel {
  int? receiveRequestId;

  SendChatRequestModel({this.receiveRequestId});

  SendChatRequestModel.fromJson(Map<String, dynamic> json) {
    receiveRequestId = json['receive_request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receive_request_id'] = this.receiveRequestId;
    return data;
  }
}
