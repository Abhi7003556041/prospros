// class RegistrationResponseModel {
//   bool? success;
//   Data? data;
//   String? message;

//   RegistrationResponseModel({this.success, this.data, this.message});

//   RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Data {
//   String? token;
//   UserDetails? userDetails;

//   Data({this.token, this.userDetails});

//   Data.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//     userDetails = json['user_details'] != null
//         ? new UserDetails.fromJson(json['user_details'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['token'] = this.token;
//     if (this.userDetails != null) {
//       data['user_details'] = this.userDetails!.toJson();
//     }
//     return data;
//   }
// }

// class UserDetails {
//   int? id;
//   String? name;
//   String? email;
//   String? contactNumber;
//   String? isPaid;
//   String? status;
//   String? createdAt;
//   String? updatedAt;

//   UserDetails(
//       {this.id,
//       this.name,
//       this.email,
//       this.contactNumber,
//       this.isPaid,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   UserDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     contactNumber = json['contact_number'];
//     isPaid = json['is_paid'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['contact_number'] = this.contactNumber;
//     data['is_paid'] = this.isPaid;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class RegistrationResponseModel {
  bool? success;
  Data? data;
  String? message;

  RegistrationResponseModel({this.success, this.data, this.message});

  RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  UserDetail? userDetail;

  Data({this.token, this.userDetail});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userDetail = json['userDetails'] != null
        ? new UserDetail.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.userDetail != null) {
      data['userDetails'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class UserDetail {
  UserDetails? userDetails;
  EducationalDetails? educationalDetails;
  CategoryDetails? professionalDetails;
  List<CategoryDetails>? categoryDetails;

  UserDetail(
      {this.userDetails,
      this.educationalDetails,
      this.professionalDetails,
      this.categoryDetails});

  UserDetail.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;

    // educationalDetails = json['educational_details'] != null &&
    //         !(json['educational_details'].runtimeType == List<dynamic>)
    //     ? json['educational_details']
    //     : null;

    // professionalDetails = json['professional_details'] != null &&
    //         !(json['professional_details'].runtimeType == List<dynamic>)
    //     ? json['professional_details']
    //     : null;

    // if (json['category_details'] != null) {
    //   categoryDetails = <CategoryDetails>[];
    //   json['category_details'].forEach((v) {
    //     categoryDetails!.add(new CategoryDetails.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    // data['educational_details'] = this.educationalDetails;
    // data['professional_details'] = this.professionalDetails;
    // if (this.categoryDetails != null) {
    //   data['category_details'] =
    //       this.categoryDetails!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? contactNumber;
  bool? emailVerify;
  String? emailVerifiedAt;
  bool? phoneVerify;
  String? phoneVerifiedAt;
  String? type;
  String? isPaid;
  String? status;
  Country? country;
  String? biography;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.id,
      this.name,
      this.email,
      this.contactNumber,
      this.emailVerify,
      this.emailVerifiedAt,
      this.phoneVerify,
      this.phoneVerifiedAt,
      this.type,
      this.isPaid,
      this.status,
      this.country,
      this.biography,
      this.profilePicture,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    emailVerify = json['email_verify'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerify = json['phone_verify'];
    phoneVerifiedAt = json['phone_verified_at'];
    type = json['type'];
    isPaid = json['is_paid'];
    status = json['status'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
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
    data['contact_number'] = this.contactNumber;
    data['email_verify'] = this.emailVerify;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verify'] = this.phoneVerify;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['type'] = this.type;
    data['is_paid'] = this.isPaid;
    data['status'] = this.status;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
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
  String? countryName;
  String? countryCode;
  String? dialCode;

  Country({this.id, this.countryName, this.countryCode, this.dialCode});

  Country.fromJson(Map<String, dynamic> json) {
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
