class LikePostModel {
  int? postId;
  String? isLike;

  LikePostModel({this.postId, this.isLike});

  LikePostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['is_like'] = this.isLike;
    return data;
  }
}
