class FileUploadRes {
  bool? success;
  List<String>? data;
  String? message;

  FileUploadRes({this.success, this.data, this.message});

  FileUploadRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'].cast<String>();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
