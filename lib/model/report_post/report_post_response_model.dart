class ReportPostSuccessModel {
  bool? success;
  Data? data;
  String? message;

  ReportPostSuccessModel({this.success, this.data, this.message});

  ReportPostSuccessModel.fromJson(Map<String, dynamic> json) {
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
  List<Null>? comments;
  List<Null>? likes;
  String? postCreatedAt;
  String? postCreatedAtRaw;

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
      this.postCreatedAt,
      this.postCreatedAtRaw});

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
    totalComments = json['total_comments'];
    totalLikes = json['total_likes'];
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     comments!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['likes'] != null) {
    //   likes = <Null>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(new Null.fromJson(v));
    //   });
    // }
    postCreatedAt = json['post_created_at'];
    postCreatedAtRaw = json['post_created_at_raw'];
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
    // if (this.comments != null) {
    //   data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    // }
    // if (this.likes != null) {
    //   data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    // }
    data['post_created_at'] = this.postCreatedAt;
    data['post_created_at_raw'] = this.postCreatedAtRaw;
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
