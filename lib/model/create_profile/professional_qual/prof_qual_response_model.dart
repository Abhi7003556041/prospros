class ProfQualResponseModel {
  bool? success;
  Data? data;
  String? message;

  ProfQualResponseModel({this.success, this.data, this.message});

  ProfQualResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  String? contactNumber;
  String? isPaid;
  String? status;
  UserDetails? userDetails;
  UserEducationalDetails? userEducationalDetails;
  UserProfessionalDetails? userProfessionalDetails;
  List<UserSubCategoryDetails>? userSubCategoryDetails;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.email,
      this.contactNumber,
      this.isPaid,
      this.status,
      this.userDetails,
      this.userEducationalDetails,
      this.userProfessionalDetails,
      this.userSubCategoryDetails,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    isPaid = json['is_paid'];
    status = json['status'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    userEducationalDetails = json['user_educational_details'] != null
        ? new UserEducationalDetails.fromJson(json['user_educational_details'])
        : null;
    userProfessionalDetails = json['user_professional_details'] != null
        ? new UserProfessionalDetails.fromJson(
            json['user_professional_details'])
        : null;
    if (json['user_sub_category_details'] != null) {
      userSubCategoryDetails = <UserSubCategoryDetails>[];
      json['user_sub_category_details'].forEach((v) {
        userSubCategoryDetails!.add(new UserSubCategoryDetails.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['is_paid'] = this.isPaid;
    data['status'] = this.status;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    if (this.userEducationalDetails != null) {
      data['user_educational_details'] = this.userEducationalDetails!.toJson();
    }
    if (this.userProfessionalDetails != null) {
      data['user_professional_details'] =
          this.userProfessionalDetails!.toJson();
    }
    if (this.userSubCategoryDetails != null) {
      data['user_sub_category_details'] =
          this.userSubCategoryDetails!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class UserDetails {
  int? id;
  int? countryId;
  CountryDetails? countryDetails;
  int? categoryId;
  CategoryDetails? categoryDetails;
  String? biography;

  UserDetails(
      {this.id,
      this.countryId,
      this.countryDetails,
      this.categoryId,
      this.categoryDetails,
      this.biography});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    countryDetails = json['country_details'] != null
        ? new CountryDetails.fromJson(json['country_details'])
        : null;
    categoryId = json['category_id'];
    categoryDetails = json['category_details'] != null
        ? new CategoryDetails.fromJson(json['category_details'])
        : null;
    biography = json['biography'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    if (this.countryDetails != null) {
      data['country_details'] = this.countryDetails!.toJson();
    }
    data['category_id'] = this.categoryId;
    if (this.categoryDetails != null) {
      data['category_details'] = this.categoryDetails!.toJson();
    }
    data['biography'] = this.biography;
    return data;
  }
}

class CountryDetails {
  int? id;
  String? countryName;
  String? countryCode;
  String? dialCode;

  CountryDetails({this.id, this.countryName, this.countryCode, this.dialCode});

  CountryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    dialCode = json['dial_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['dial_code'] = this.dialCode;
    return data;
  }
}

class CategoryDetails {
  int? id;
  String? categoryName;
  String? categorySlug;
  String? categoryDescription;
  int? parentId;
  String? status;

  CategoryDetails(
      {this.id,
      this.categoryName,
      this.categorySlug,
      this.categoryDescription,
      this.parentId,
      this.status});

  CategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    categoryDescription = json['category_description'];
    parentId = json['parent_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_slug'] = this.categorySlug;
    data['category_description'] = this.categoryDescription;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    return data;
  }
}

class UserEducationalDetails {
  int? id;
  int? userId;
  String? areaOfSpecialization;
  String? highestQualification;

  UserEducationalDetails(
      {this.id,
      this.userId,
      this.areaOfSpecialization,
      this.highestQualification});

  UserEducationalDetails.fromJson(Map<String, dynamic> json) {
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

class UserProfessionalDetails {
  int? id;
  int? userId;
  String? occupation;
  String? description;
  String? officeName;

  UserProfessionalDetails(
      {this.id,
      this.userId,
      this.occupation,
      this.description,
      this.officeName});

  UserProfessionalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    occupation = json['occupation'];
    description = json['description'];
    officeName = json['office_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['occupation'] = this.occupation;
    data['description'] = this.description;
    data['office_name'] = this.officeName;
    return data;
  }
}

class UserSubCategoryDetails {
  int? id;
  int? userId;
  int? subCategoryId;
  List<SubCategoryDetails>? subCategoryDetails;

  UserSubCategoryDetails(
      {this.id, this.userId, this.subCategoryId, this.subCategoryDetails});

  UserSubCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subCategoryId = json['sub_category_id'];
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
    data['user_id'] = this.userId;
    data['sub_category_id'] = this.subCategoryId;
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
  String? categorySlug;
  String? categoryDescription;
  int? parentId;
  String? status;

  SubCategoryDetails(
      {this.id,
      this.categoryName,
      this.categorySlug,
      this.categoryDescription,
      this.parentId,
      this.status});

  SubCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    categoryDescription = json['category_description'];
    parentId = json['parent_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_slug'] = this.categorySlug;
    data['category_description'] = this.categoryDescription;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    return data;
  }
}
