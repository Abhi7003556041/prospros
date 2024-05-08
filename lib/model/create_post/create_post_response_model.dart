class CreatePostResponseModel {
  bool? success;
  Data? data;
  String? message;

  CreatePostResponseModel({this.success, this.data, this.message});

  CreatePostResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? status;
  PostCategoryDetails? postCategoryDetails;
  String? postCreatedAt;

  Data(
      {this.id,
      this.postTitle,
      this.postDescription,
      this.postImages,
      this.postedBy,
      this.status,
      this.postCategoryDetails,
      this.postCreatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postTitle = json['post_title'];
    postDescription = json['post_description'];
    postImages = json['post_images'];
    postedBy = json['posted_by'] != null
        ? new PostedBy.fromJson(json['posted_by'])
        : null;
    status = json['status'];
    postCategoryDetails = json['post_category_details'] != null
        ? new PostCategoryDetails.fromJson(json['post_category_details'])
        : null;
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
    data['status'] = this.status;
    if (this.postCategoryDetails != null) {
      data['post_category_details'] = this.postCategoryDetails!.toJson();
    }
    data['post_created_at'] = this.postCreatedAt;
    return data;
  }
}

class PostedBy {
  String? name;

  PostedBy({this.name});

  PostedBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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
