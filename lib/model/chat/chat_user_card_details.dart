import 'package:prospros/router/navrouter_constants.dart';

class ChatUserListModel {
  String? userName;
  String? profileImageUrl;
  bool? isOnline;
  String? lastChatMessage;
  String? lastChatMessageTime;
  int? unreadMsgCount;

  ChatUserListModel(
      {this.userName,
      this.isOnline,
      this.profileImageUrl,
      this.lastChatMessage,
      this.unreadMsgCount,
      this.lastChatMessageTime});

  ChatUserListModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    isOnline = json['isOnline'];
    unreadMsgCount = json['unreadMsgCount'];
    lastChatMessage = json['lastChatMessage'];
    lastChatMessageTime = json['lastChatMessageTime'];
    profileImageUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['isOnline'] = this.isOnline;
    data['unreadMsgCount'] = this.unreadMsgCount;
    data['lastChatMessage'] = this.lastChatMessage;
    data['lastChatMessageTime'] = this.lastChatMessageTime;
    data['profileUrl'] = profileImageUrl;
    return data;
  }
}
