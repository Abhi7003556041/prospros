import 'dart:convert';

class BraintreeClientTokenRes {
  final bool success;
  final BraintreeClientTokenData data;
  final String message;
  BraintreeClientTokenRes({
    required this.success,
    required this.data,
    required this.message,
  });

  BraintreeClientTokenRes copyWith({
    bool? success,
    BraintreeClientTokenData? data,
    String? message,
  }) {
    return BraintreeClientTokenRes(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data.toMap(),
      'message': message,
    };
  }

  factory BraintreeClientTokenRes.fromMap(Map<String, dynamic> map) {
    return BraintreeClientTokenRes(
      success: map['success'] as bool,
      data:
          BraintreeClientTokenData.fromMap(map['data'] as Map<String, dynamic>),
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BraintreeClientTokenRes.fromJson(String source) =>
      BraintreeClientTokenRes.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BraintreeClientTokenRes(success: $success, data: $data, message: $message)';

  @override
  bool operator ==(covariant BraintreeClientTokenRes other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.data == data &&
        other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode ^ message.hashCode;
}

class BraintreeClientTokenData {
  final String client_token;
  BraintreeClientTokenData({
    required this.client_token,
  });

  BraintreeClientTokenData copyWith({
    String? client_token,
  }) {
    return BraintreeClientTokenData(
      client_token: client_token ?? this.client_token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'client_token': client_token,
    };
  }

  factory BraintreeClientTokenData.fromMap(Map<String, dynamic> map) {
    return BraintreeClientTokenData(
      client_token: map['client_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BraintreeClientTokenData.fromJson(String source) =>
      BraintreeClientTokenData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BraintreeClientTokenData(client_token: $client_token)';

  @override
  bool operator ==(covariant BraintreeClientTokenData other) {
    if (identical(this, other)) return true;

    return other.client_token == client_token;
  }

  @override
  int get hashCode => client_token.hashCode;
}
