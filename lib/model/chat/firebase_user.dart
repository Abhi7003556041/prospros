class FirebaseUser {
  String? profileUrl;
  FriendList? friendList;
  String? name;
  bool? isOnline;
  String? lastPresenceAt;
  String? status;

  FirebaseUser(
      {this.profileUrl,
      this.friendList,
      this.name,
      this.isOnline,
      this.lastPresenceAt,
      this.status});

  FirebaseUser.fromJson(Map<dynamic?, dynamic?> json) {
    profileUrl = json['profileUrl'];
    friendList = json['friend_list'] != null
        ? new FriendList.fromJson(json['friend_list'])
        : null;
    name = json['name'];
    isOnline = json['isOnline'];
    lastPresenceAt = json['lastPresenceAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileUrl'] = this.profileUrl;
    if (this.friendList != null) {
      data['friend_list'] = this.friendList!.toJson();
    }
    data['name'] = this.name;
    data['isOnline'] = this.isOnline;
    data['lastPresenceAt'] = this.lastPresenceAt;
    data['status'] = this.status;
    return data;
  }
}

class FriendList {
  ProsUser119? prosUser119;

  FriendList({this.prosUser119});

  FriendList.fromJson(Map<String, dynamic> json) {
    prosUser119 = json['pros_user119'] != null
        ? new ProsUser119.fromJson(json['pros_user119'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prosUser119 != null) {
      data['pros_user119'] = this.prosUser119!.toJson();
    }
    return data;
  }
}

class ProsUser119 {
  String? lastChat;
  String? userId;
  String? chatRoomId;
  String? status;

  ProsUser119({this.lastChat, this.userId, this.chatRoomId, this.status});

  ProsUser119.fromJson(Map<String, dynamic> json) {
    lastChat = json['lastChat'];
    userId = json['user_id'];
    chatRoomId = json['chat_room_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastChat'] = this.lastChat;
    data['user_id'] = this.userId;
    data['chat_room_id'] = this.chatRoomId;
    data['status'] = this.status;
    return data;
  }
}
