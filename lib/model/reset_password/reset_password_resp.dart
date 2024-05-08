class ResetPasswordResp {
  bool? success;
  String? data;
  String? message;

  ResetPasswordResp({this.success, this.data, this.message});

  ResetPasswordResp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'].toString();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  UserDetails? userDetails;
  EducationalDetails? educationalDetails;
  ProfessionalDetails? professionalDetails;
  CategoryDetails? categoryDetails;

  Data(
      {this.userDetails,
      this.educationalDetails,
      this.professionalDetails,
      this.categoryDetails});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    educationalDetails = json['educational_details'] != null
        ? new EducationalDetails.fromJson(json['educational_details'])
        : null;
    professionalDetails = json['professional_details'] != null
        ? new ProfessionalDetails.fromJson(json['professional_details'])
        : null;
    categoryDetails = json['category_details'] != null
        ? new CategoryDetails.fromJson(json['category_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
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

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? phoneCode;
  String? contactNumber;
  bool? emailVerify;
  String? emailVerifiedAt;
  bool? phoneVerify;
  String? phoneVerifiedAt;
  String? type;
  String? isPaid;
  String? socialType;
  String? socialId;
  String? status;
  Country? country;
  Subscription? subscription;
  String? biography;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.id,
      this.name,
      this.email,
      this.phoneCode,
      this.contactNumber,
      this.emailVerify,
      this.emailVerifiedAt,
      this.phoneVerify,
      this.phoneVerifiedAt,
      this.type,
      this.isPaid,
      this.socialType,
      this.socialId,
      this.status,
      this.country,
      this.subscription,
      this.biography,
      this.profilePicture,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneCode = json['phone_code'].toString();
    contactNumber = json['contact_number'];
    emailVerify = json['email_verify'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerify = json['phone_verify'];
    phoneVerifiedAt = json['phone_verified_at'];
    type = json['type'];
    isPaid = json['is_paid'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    status = json['status'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    biography = json['biography'];
    profilePicture = json['profile_picture'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['contact_number'] = this.contactNumber;
    data['email_verify'] = this.emailVerify;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verify'] = this.phoneVerify;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['type'] = this.type;
    data['is_paid'] = this.isPaid;
    data['social_type'] = this.socialType;
    data['social_id'] = this.socialId;
    data['status'] = this.status;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    data['biography'] = this.biography;
    data['profile_picture'] = this.profilePicture;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  Subscription.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class EducationalDetails {
  int? id;
  int? userId;
  String? areaOfSpecialization;
  String? highestQualification;

  EducationalDetails(
      {this.id,
      this.userId,
      this.areaOfSpecialization,
      this.highestQualification});

  EducationalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    areaOfSpecialization = json['area_of_specialization'];
    highestQualification = json['highest_qualification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['area_of_specialization'] = this.areaOfSpecialization;
    data['highest_qualification'] = this.highestQualification;
    return data;
  }
}

class ProfessionalDetails {
  int? id;
  int? userId;
  String? professionalDesignation;
  String? professionalField;
  String? officeName;

  ProfessionalDetails(
      {this.id,
      this.userId,
      this.professionalDesignation,
      this.professionalField,
      this.officeName});

  ProfessionalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    professionalDesignation = json['professional_designation'];
    professionalField = json['professional_field'];
    officeName = json['office_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['professional_designation'] = this.professionalDesignation;
    data['professional_field'] = this.professionalField;
    data['office_name'] = this.officeName;
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

  SubCategory({this.id, this.categoryName});

  SubCategory.fromJson(Map<String, dynamic> json) {
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
