class CommunityResponseModel {
  bool? success;
  Data? data;
  String? message;

  CommunityResponseModel({this.success, this.data, this.message});

  CommunityResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<CommunityData>? communityData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.communityData,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      communityData = <CommunityData>[];
      json['data'].forEach((v) {
        communityData!.add(new CommunityData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.communityData != null) {
      data['data'] = this.communityData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class CommunityData {
  int? id;
  String? name;
  String? email;
  String? phoneCode;
  String? contactNumber;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? type;
  String? isPaid;
  String? socialType;
  String? socialId;
  String? status;
  String? createdAt;
  String? updatedAt;
  UserDetails? userDetails;
  EducationalDetails? educationalDetails;
  ProfessionalDetails? professionalDetails;
  CategoryDetails? categoryDetails;

  CommunityData(
      {this.userDetails,
      this.id,
      this.name,
      this.email,
      this.phoneCode,
      this.contactNumber,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.type,
      this.isPaid,
      this.socialType,
      this.socialId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.categoryDetails,
      this.educationalDetails,
      this.professionalDetails});

  CommunityData.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneCode = json['phone_code'].toString();
    contactNumber = json['contact_number'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    type = json['type'];
    isPaid = json['is_paid'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    educationalDetails = json['educational_details'] != null &&
            !(json['educational_details'].runtimeType == List<dynamic>)
        ? new EducationalDetails.fromJson(json['educational_details'])
        : null;

    professionalDetails = json['professional_details'] != null &&
            !(json['professional_details'].runtimeType == List<dynamic>)
        ? new ProfessionalDetails.fromJson(json['professional_details'])
        : null;

    categoryDetails = json['category_details'] != null &&
            !(json['category_details'].runtimeType == List<dynamic>)
        ? new CategoryDetails.fromJson(json['category_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
      data['id'] = this.id;
      data['name'] = this.name;
      data['email'] = this.email;
      data['phone_code'] = this.phoneCode;
      data['contact_number'] = this.contactNumber;
      data['email_verified_at'] = this.emailVerifiedAt;
      data['phone_verified_at'] = this.phoneVerifiedAt;
      data['type'] = this.type;
      data['is_paid'] = this.isPaid;
      data['social_type'] = this.socialType;
      data['social_id'] = this.socialId;
      data['status'] = this.status;
      data['created_at'] = this.createdAt;
      data['updated_at'] = this.updatedAt;
    }
    if (this.educationalDetails != null) {
      data['educational_details'] = this.educationalDetails!.toJson();
    }
    if (this.professionalDetails != null) {
      data['professional_details'] = this.professionalDetails!.toJson();
    }
    if (this.categoryDetails != null) {
      data['category_details'] = this.categoryDetails!.toJson();
    }
    return data;
  }
}

class ChatRequests {
  String? isInitiate;
  int? id;
  String? initiateType;
  Receiver? receiver;

  ChatRequests({this.isInitiate, this.id, this.initiateType, this.receiver});

  ChatRequests.fromJson(Map<String, dynamic> json) {
    isInitiate = json['is_initiate'];
    id = json['id'];
    initiateType = json['initiate_type'];
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_initiate'] = this.isInitiate;
    data['id'] = this.id;
    data['initiate_type'] = this.initiateType;
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    return data;
  }
}

class Receiver {
  int? id;
  String? name;
  String? roomId;

  Receiver({this.id, this.name, this.roomId});

  Receiver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['room_id'] = this.roomId;
    return data;
  }
}

class CategoryDetails {
  Category? category;

  CategoryDetails({this.category});

  CategoryDetails.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? categoryName;
  List<SubCategory>? subCategory;

  Category({this.id, this.categoryName, this.subCategory});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  String? categoryName;
  String? categorySlug;
  String? categoryDescription;
  String? categoryIcon;
  int? parentId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  SubCategory(
      {this.id,
      this.categoryName,
      this.categorySlug,
      this.categoryDescription,
      this.categoryIcon,
      this.parentId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    categoryDescription = json['category_description'];
    categoryIcon = json['category_icon'];
    parentId = json['parent_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_slug'] = this.categorySlug;
    data['category_description'] = this.categoryDescription;
    data['category_icon'] = this.categoryIcon;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? categoryId;

  Pivot({this.userId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
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

class EducationalDetails {
  int? id;
  int? userId;
  String? areaOfSpecialization;
  String? highestQualification;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  EducationalDetails(
      {this.id,
      this.userId,
      this.areaOfSpecialization,
      this.highestQualification,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  EducationalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    areaOfSpecialization = json['area_of_specialization'];
    highestQualification = json['highest_qualification'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['area_of_specialization'] = this.areaOfSpecialization;
    data['highest_qualification'] = this.highestQualification;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class ProfessionalDetails {
  int? id;
  int? userId;
  String? professionalDesignation;
  String? professionalField;
  String? officeName;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ProfessionalDetails(
      {this.id,
      this.userId,
      this.professionalDesignation,
      this.professionalField,
      this.officeName,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProfessionalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    professionalDesignation = json['professional_designation'];
    professionalField = json['professional_field'];
    officeName = json['office_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['professional_designation'] = this.professionalDesignation;
    data['professional_field'] = this.professionalField;
    data['office_name'] = this.officeName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class UserDetails {
  int? id;
  int? userId;
  int? countryId;
  int? categoryId;
  String? biography;
  String? profilePicture;
  int? subscriptionId;
  String? createdAt;
  String? updatedAt;
  Country? country;
  Subscription? subscription;

  UserDetails(
      {this.id,
      this.userId,
      this.countryId,
      this.categoryId,
      this.biography,
      this.profilePicture,
      this.subscriptionId,
      this.createdAt,
      this.updatedAt,
      this.country,
      this.subscription});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    countryId = json['country_id'];
    categoryId = json['category_id'];
    biography = json['biography'];
    profilePicture = json['profile_picture'];
    subscriptionId = json['subscription_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['country_id'] = this.countryId;
    data['category_id'] = this.categoryId;
    data['biography'] = this.biography;
    data['profile_picture'] = this.profilePicture;
    data['subscription_id'] = this.subscriptionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
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

class Subscription {
  int? id;
  String? planName;
  String? planAmount;
  String? planDuration;
  String? planDerscription;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Subscription(
      {this.id,
      this.planName,
      this.planAmount,
      this.planDuration,
      this.planDerscription,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    planAmount = json['plan_amount'];
    planDuration = json['plan_duration'];
    planDerscription = json['plan_derscription'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_name'] = this.planName;
    data['plan_amount'] = this.planAmount;
    data['plan_duration'] = this.planDuration;
    data['plan_derscription'] = this.planDerscription;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
