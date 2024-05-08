import 'dart:io';

class CreatePostModel {
  String? postTitle;
  String? postDescription;
  String? postImages;

  CreatePostModel({this.postTitle, this.postDescription, this.postImages});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    postTitle = json['post_title'];
    postDescription = json['post_description'];
    postImages = json['post_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_title'] = this.postTitle;
    data['post_description'] = this.postDescription;
    return data;
  }
}
