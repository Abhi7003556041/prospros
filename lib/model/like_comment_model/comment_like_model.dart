class CommentLikeModel {
  int? commentId;
  String? isLike;

  CommentLikeModel({this.commentId, this.isLike});

  CommentLikeModel.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['is_like'] = this.isLike;
    return data;
  }
}
