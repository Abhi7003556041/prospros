class ChatHistoryResponseModel {
  bool? success;
  Data? data;
  String? message;

  ChatHistoryResponseModel({this.success, this.data, this.message});

  ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<ChatData>? chatData;
  Links? links;
  Meta? meta;

  Data({this.chatData, this.links, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      chatData = <ChatData>[];
      json['data'].forEach((v) {
        chatData!.add(new ChatData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chatData != null) {
      data['data'] = this.chatData!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class ChatData {
  int? id;
  int? senderId;
  SenderDetails? senderDetails;
  int? receiverId;
  SenderDetails? receiverDetails;
  String? roomId;
  String? message;
  String? createdAt;

  ChatData(
      {this.id,
      this.senderId,
      this.senderDetails,
      this.receiverId,
      this.receiverDetails,
      this.roomId,
      this.message,
      this.createdAt});

  ChatData.fromJson(Map<String, dynamic> json) {
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

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLinks>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.links,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <MetaLinks>[];
      json['links'].forEach((v) {
        links!.add(new MetaLinks.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class MetaLinks {
  String? url;
  String? label;
  bool? active;

  MetaLinks({this.url, this.label, this.active});

  MetaLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
