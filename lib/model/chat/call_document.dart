class CallDocument {
  String? callerFirebaseId;
  String? reciverFirebaseId;

  ///used to join the channel; it's server-user-id
  int? reciverId;
  String? timestamp;
  //only used when a channel has only one token ; which can be used to join for any users
  String? callToken;
  //this token will be used by call-receiver to join the channel [if callToken is implemented then it will not be used]
  String? receiverCallToken;
  //this token will be used by caller to join the channel [if callToken is implemented then it will not be used]
  String? callerCallToken;
  String? channelId;
  String? agoraAppId;
  String? callType;
  String? callerName;
  String? callerProfileImage;

  CallDocument(
      {this.callerFirebaseId,
      this.reciverFirebaseId,
      this.timestamp,
      this.callToken,
      this.channelId,
      this.agoraAppId,
      this.callerName,
      this.reciverId,
      this.callerProfileImage,
      this.callerCallToken,
      this.receiverCallToken,
      this.callType});

  CallDocument.fromJson(Map<String, dynamic> json) {
    callerFirebaseId = json['callerFirebaseId'];
    reciverFirebaseId = json['reciverFirebaseId'];
    timestamp = json['timestamp'];
    callToken = json['callToken'];
    channelId = json['channelId'];
    agoraAppId = json['agoraAppId'];
    callType = json['callType'];
    reciverId = json['receiverId'];
    callerCallToken = json['callerCallToken'];
    receiverCallToken = json['receiverCallToken'];
    callerProfileImage = json['callerProfileImage'];
    callerName = json['callerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callerCallToken'] = this.callerCallToken;
    data['receiverCallToken'] = this.receiverCallToken;
    data['callerFirebaseId'] = this.callerFirebaseId;
    data['reciverFirebaseId'] = this.reciverFirebaseId;
    data['timestamp'] = this.timestamp;
    data['callToken'] = this.callToken;
    data['channelId'] = this.channelId;
    data['callType'] = this.callType;
    data['callerName'] = callerName;
    data['receiverId'] = reciverId;
    data['agoraAppId'] = agoraAppId;
    data['callerProfileImage'] = callerProfileImage;
    return data;
  }
}
