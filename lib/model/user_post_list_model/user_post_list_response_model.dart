import 'dart:convert';

import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';

import '../login/login_response_model.dart';

class UserPostResponseModel {
  bool? success;
  Data? data;
  String? message;

  UserPostResponseModel({this.success, this.data, this.message});

  UserPostResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<PostListData>? postListData;
  Links? links;
  Meta? meta;

  Data({this.postListData, this.links, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      postListData = <PostListData>[];
      json['data'].forEach((v) {
        postListData!.add(new PostListData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postListData != null) {
      data['data'] = this.postListData!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class PostListData {
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
  List<Comments>? comments;
  List<Likes>? likes;
  String? postCreatedAt;
  String? postCreatedAtRAW;

  //Defined to use this variables as reactive, if in case of changes update these values as is to be functional
  var rxTotalLikes = 0.obs;
  var isLiked = false.obs;
  var userId = 0.obs;
  var rxTotalComments = (-1).obs;

  setUserId() {
    final data = json.decode(HiveStore().get(Keys.userDetails));
    final loginResponseModel = LoginResponseModel.fromJson(data);
    userId.value =
        loginResponseModel.data?.personalDetails?.userDetails?.id! ?? 0;
  }

  PostListData(
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

  PostListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postTitle = json['post_title'];
    postDescription = json['post_description'];
    postImages = json['post_images'];
    postedByImage = json['posted_by_image'];
    postedBy = json['posted_by'] != null
        ? new PostedBy.fromJson(json['posted_by'])
        : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    status = json['status'];
    postCategoryDetails = json['post_category_details'] != null
        ? new PostCategoryDetails.fromJson(json['post_category_details'])
        : null;
    totalComments = json['total_comments'];

    ///Added Manuallly
    rxTotalComments.value = json['total_comments'];
    totalLikes = json['total_likes'];

    ///Added Manuallly
    rxTotalLikes.value = json['total_likes'];

    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    if (json['likes'] != null) {
      likes = <Likes>[];
      //Sets the Current userId value
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
    postCreatedAtRAW = json['post_created_at_raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_title'] = this.postTitle;
    data['post_description'] = this.postDescription;
    data['post_images'] = this.postImages;
    data['posted_by_image'] = this.postedByImage;
    if (this.postedBy != null) {
      data['posted_by'] = this.postedBy!.toJson();
    }
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
    data['post_created_at_raw'] = this.postCreatedAtRAW;
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
  List<SubcatagoryList>? subcatagoryList;

  PostCategoryDetails({this.id, this.categoryName, this.subcatagoryList});

  PostCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['subcatagory_list'] != null) {
      subcatagoryList = <SubcatagoryList>[];
      json['subcatagory_list'].forEach((v) {
        subcatagoryList!.add(new SubcatagoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.subcatagoryList != null) {
      data['subcatagory_list'] =
          this.subcatagoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubcatagoryList {
  int? id;
  String? categoryName;

  SubcatagoryList({this.id, this.categoryName});

  SubcatagoryList.fromJson(Map<String, dynamic> json) {
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
  int? totalLike;
  List<SubComments>? subComments;
  bool? isUserLike;

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
    totalLike = json['total_like'];
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
    data["is_user_like"] = isUserLike;
    data['total_like'] = this.totalLike;
    data['comment_created_at'] = this.commentCreatedAt;
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
  String? totalLike;
  bool? isUserLike;

  SubComments(
      {this.id,
      this.commentText,
      this.user,
      this.commentCreatedAt,
      this.userImage,
      this.isUserLike,
      this.totalLike});

  SubComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['comment_text'];
    user = json['user'];
    commentCreatedAt = json['comment_created_at'];
    totalLike = json['total_like'];
    isUserLike = json["is_user_like"];
    userImage = json['user_image'];
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

  Likes({this.id, this.isLike, this.user, this.userId});

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

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLinks>? metaLinks;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.metaLinks,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['metaLinks'] != null) {
      metaLinks = <MetaLinks>[];
      json['metaLinks'].forEach((v) {
        metaLinks!.add(new MetaLinks.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.metaLinks != null) {
      data['metaLinks'] = this.metaLinks!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class MetaLinks {
  String? url;
  String? label;
  bool? active;

  MetaLinks({this.url, this.label, this.active});

  MetaLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
