class SendChatMessageResponseModel {
  bool? success;
  Data? data;
  String? message;

  SendChatMessageResponseModel({this.success, this.data, this.message});

  SendChatMessageResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? senderId;
  SenderDetails? senderDetails;
  int? receiverId;
  SenderDetails? receiverDetails;
  String? roomId;
  String? message;
  String? createdAt;

  Data(
      {this.id,
      this.senderId,
      this.senderDetails,
      this.receiverId,
      this.receiverDetails,
      this.roomId,
      this.message,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    senderDetails = json['sender_details'] != null
        ? new SenderDetails.fromJson(json['sender_details'])
        : null;
    receiverId = json['receiver_id'];
    receiverDetails = json['receiver_details'] != null
        ? new SenderDetails.fromJson(json['receiver_details'])
        : null;
    roomId = json['room_id'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    if (this.senderDetails != null) {
      data['sender_details'] = this.senderDetails!.toJson();
    }
    data['receiver_id'] = this.receiverId;
    if (this.receiverDetails != null) {
      data['receiver_details'] = this.receiverDetails!.toJson();
    }
    data['room_id'] = this.roomId;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class SenderDetails {
  int? id;
  String? name;
  String? email;
  String? contactNumber;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? type;
  String? isPaid;
  String? status;
  String? createdAt;
  String? updatedAt;

  SenderDetails(
      {this.id,
      this.name,
      this.email,
      this.contactNumber,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.type,
      this.isPaid,
      this.status,
      this.createdAt,
      this.updatedAt});

  SenderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    type = json['type'];
    isPaid = json['is_paid'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['type'] = this.type;
    data['is_paid'] = this.isPaid;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
