import 'dart:convert';

import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/login/login_response_model.dart';

class PostDetailsResponseModel {
  bool? success;
  Data? data;
  String? message;

  PostDetailsResponseModel({this.success, this.data, this.message});

  PostDetailsResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? postTitle;
  String? postDescription;
  String? postImages;
  PostedBy? postedBy;
  String? postedByImage;
  Country? country;
  String? status;
  PostCategoryDetails? postCategoryDetails;
  int? totalComments;
  int? totalLikes;
  RxList<Comments>? comments = <Comments>[].obs; //Alter from Default response
  List<Likes>? likes;
  String? postCreatedAt;

  //Defined to use this variables as reactive, if in case of changes update these values as is to be functional
  var rxTotalLikes = 0.obs;
  var isLiked = false.obs;
  var userId = 0.obs;
  var rxTotalComments = (-1).obs;

  setUserId() {
    final data = json.decode(HiveStore().get(Keys.userDetails));
    final loginResponseModel = LoginResponseModel.fromJson(data);
    userId.value =
        loginResponseModel.data?.personalDetails?.userDetails?.id ?? 0;

    print("User Id =============");
    print(userId);
  }

  Data(
      {this.id,
      this.postTitle,
      this.postDescription,
      this.postImages,
      this.postedBy,
      this.postedByImage,
      this.country,
      this.status,
      this.postCategoryDetails,
      this.totalComments,
      this.totalLikes,
      this.comments,
      this.likes,
      this.postCreatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postTitle = json['post_title'];
    postDescription = json['post_description'];
    postImages = json['post_images'];
    postedBy = json['posted_by'] != null
        ? new PostedBy.fromJson(json['posted_by'])
        : null;
    postedByImage = json['posted_by_image'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    status = json['status'];
    postCategoryDetails = json['post_category_details'] != null
        ? new PostCategoryDetails.fromJson(json['post_category_details'])
        : null;

    ///Added Manuallly
    rxTotalLikes.value = json['total_likes'];

    // totalComments = json['total_comments'];
    //Added Manually
    rxTotalComments.value = json['total_comments'];

    totalLikes = json['total_likes'];
    if (json['comments'] != null) {
      comments?.value = <Comments>[].obs;
      json['comments'].forEach((v) {
        comments?.add(new Comments.fromJson(v));
      });
    }
    if (json['likes'] != null) {
      likes = <Likes>[];
      setUserId();
      json['likes'].forEach((v) {
        //Added Manually
        final newLikes = Likes.fromJson(v);
        likes!.add(newLikes);
        if (newLikes.userId == userId.value) {
          isLiked.value = true;
        }
      });
    }
    postCreatedAt = json['post_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_title'] = this.postTitle;
    data['post_description'] = this.postDescription;
    data['post_images'] = this.postImages;
    if (this.postedBy != null) {
      data['posted_by'] = this.postedBy!.toJson();
    }
    data['posted_by_image'] = this.postedByImage;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['status'] = this.status;
    if (this.postCategoryDetails != null) {
      data['post_category_details'] = this.postCategoryDetails!.toJson();
    }

    data['total_comments'] = this.totalComments;
    data['total_likes'] = this.totalLikes;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    data['post_created_at'] = this.postCreatedAt;
    return data;
  }
}

class PostedBy {
  int? id;
  String? name;

  PostedBy({this.id, this.name});

  PostedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Country {
  int? id;
  String? shortname;
  String? name;
  int? phonecode;
  String? flag;

  Country({this.id, this.shortname, this.name, this.phonecode, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortname = json['shortname'];
    name = json['name'];
    phonecode = json['phonecode'] is int ? json['phonecode'] : null;
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shortname'] = this.shortname;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    data['flag'] = this.flag;
    return data;
  }
}

class PostCategoryDetails {
  int? id;
  String? categoryName;
  List<SubCategoryDetails>? subCategoryDetails;

  PostCategoryDetails({this.id, this.categoryName, this.subCategoryDetails});

  PostCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['sub_category_details'] != null) {
      subCategoryDetails = <SubCategoryDetails>[];
      json['sub_category_details'].forEach((v) {
        subCategoryDetails!.add(new SubCategoryDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.subCategoryDetails != null) {
      data['sub_category_details'] =
          this.subCategoryDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryDetails {
  int? id;
  String? categoryName;

  SubCategoryDetails({this.id, this.categoryName});

  SubCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Comments {
  int? id;
  String? commentText;
  String? user;
  String? userImage;
  String? commentCreatedAt;
  RxInt? totalLike = 0.obs;
  List<SubComments>? subComments;
  bool? isUserLike;
  RxBool? isLiked = false.obs;

  Comments(
      {this.id,
      this.commentText,
      this.user,
      this.userImage,
      this.commentCreatedAt,
      this.totalLike,
      this.isUserLike,
      this.subComments});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['comment_text'];
    user = json['user'];
    userImage = json['user_image'];
    commentCreatedAt = json['comment_created_at'];
    totalLike?.value = json['total_like'];
    isUserLike = json["is_user_like"];
    if (json['sub_comments'] != null) {
      subComments = <SubComments>[];
      json['sub_comments'].forEach((v) {
        subComments!.add(new SubComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_text'] = this.commentText;
    data['user'] = this.user;
    data['user_image'] = this.userImage;
    data['comment_created_at'] = this.commentCreatedAt;
    data['total_like'] = this.totalLike?.value;
    data["is_user_like"] = this.isUserLike;
    if (this.subComments != null) {
      data['sub_comments'] = this.subComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubComments {
  int? id;
  String? commentText;
  String? user;
  String? userImage;
  String? commentCreatedAt;
  int? totalLike;
  bool? isUserLike;

  SubComments(
      {this.id,
      this.commentText,
      this.user,
      this.userImage,
      this.commentCreatedAt,
      this.isUserLike,
      this.totalLike});

  SubComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['comment_text'];
    user = json['user'];
    userImage = json['user_image'];
    commentCreatedAt = json['comment_created_at'];
    totalLike = json['total_like'];
    isUserLike = json["is_user_like"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_text'] = this.commentText;
    data['user'] = this.user;
    data['user_image'] = this.userImage;
    data['comment_created_at'] = this.commentCreatedAt;
    data['total_like'] = this.totalLike;
    data["is_user_like"] = this.isUserLike;
    return data;
  }
}

class Likes {
  int? id;
  String? isLike;
  String? user;
  int? userId;

  Likes({this.id, this.isLike, this.user});

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isLike = json['is_like'];
    user = json['user'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_like'] = this.isLike;
    data['user'] = this.user;
    data['user_id'] = this.userId;
    return data;
  }
}
