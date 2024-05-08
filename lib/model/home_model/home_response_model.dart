import 'dart:convert';

import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/login/login_response_model.dart';

class HomeResponseModel {
  bool? success;
  Data? data;
  String? message;

  HomeResponseModel({this.success, this.data, this.message});

  HomeResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<HomeData>? homeData;
  PageLinks? pageLinks;
  Meta? meta;

  Data({this.homeData, this.pageLinks, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      homeData = <HomeData>[];
      json['data'].forEach((v) {
        homeData!.add(new HomeData.fromJson(v));
      });
    }
    pageLinks =
        json['links'] != null ? new PageLinks.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeData != null) {
      data['data'] = this.homeData!.map((v) => v.toJson()).toList();
    }
    if (this.pageLinks != null) {
      data['links'] = this.pageLinks!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class HomeData {
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

  //Defined to use this variables as reactive, if in case of model changes update these values as is to be functional
  var rxTotalLikes = 0.obs;
  var isLiked = false.obs;
  var userId = 0.obs;

  var rxTotalComments = 0.obs;

  HomeData(
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
      this.postCreatedAtRAW,
      this.likes,
      this.postCreatedAt});

  setUserId() {
    final data = json.decode(HiveStore().get(Keys.userDetails));
    final loginResponseModel = LoginResponseModel.fromJson(data);
    userId.value =
        loginResponseModel.data?.personalDetails?.userDetails?.id! ?? 0;
  }

  HomeData.fromJson(Map<String, dynamic> json) {
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
    totalComments = json['total_comments'];
    rxTotalComments.value = json['total_comments'];
    totalLikes = json['total_likes'];

    //Replaced totallikes with rxTotalLikes
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
        final newLikes = Likes.fromJson(v);
        likes!.add(newLikes);
        if (newLikes.userId == userId.value) {
          // isLiked is value set manually in the HomeResponseModel for checking is the user liked the post
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
    data["post_created_at_raw"] = this.postCreatedAtRAW;
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
    phonecode = json['phonecode'];
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
  int? totalLike;
  List<SubComments>? subComments;

  Comments(
      {this.id,
      this.commentText,
      this.user,
      this.userImage,
      this.commentCreatedAt,
      this.totalLike,
      this.subComments});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['comment_text'];
    user = json['user'];
    userImage = json['user_image'];
    commentCreatedAt = json['comment_created_at'];
    totalLike = json['total_like'];
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
    data['total_like'] = this.totalLike;
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

  SubComments(
      {this.id,
      this.commentText,
      this.user,
      this.userImage,
      this.commentCreatedAt,
      this.totalLike});

  SubComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentText = json['comment_text'];
    user = json['user'];
    userImage = json['user_image'];
    commentCreatedAt = json['comment_created_at'];
    totalLike = json['total_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_text'] = this.commentText;
    data['user'] = this.user;
    data['user_image'] = this.userImage;
    data['comment_created_at'] = this.commentCreatedAt;
    data['total_like'] = this.totalLike;
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

class PageLinks {
  String? first;
  String? last;
  String? prev;
  String? next;

  PageLinks({this.first, this.last, this.prev, this.next});

  PageLinks.fromJson(Map<String, dynamic> json) {
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
  List<Links>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.links,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
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
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
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
