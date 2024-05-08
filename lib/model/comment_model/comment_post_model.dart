class CommentPostModel {
  int? postId;
  String? commentText;
  int? commentId;

  CommentPostModel({this.postId, this.commentText, this.commentId});

  CommentPostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    commentText = json['comment_text'];
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['comment_text'] = this.commentText;
    data['comment_id'] = this.commentId;
    return data;
  }
}
