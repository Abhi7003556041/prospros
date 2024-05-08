class ProfQualModel {
  int? categoryId;
  List<int>? subCategoryId;
  String? highestQualification;
  String? areaOfSpecialization;
  String? professionalDesignation;
  String? professionalField;
  String? officeName;
  String? biography;

  ///possible value can be "yes" or "no"
  String? twoFactorAuth;

  ProfQualModel(
      {this.categoryId,
      this.subCategoryId,
      this.highestQualification,
      this.areaOfSpecialization,
      this.professionalDesignation,
      this.professionalField,
      this.officeName,
      this.twoFactorAuth,
      this.biography});

  ProfQualModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'].cast<int>();
    highestQualification = json['highest_qualification'];
    areaOfSpecialization = json['area_of_specialization'];
    professionalDesignation = json['professional_designation'];
    professionalField = json['professional_field'];
    officeName = json['office_name'];
    biography = json['biography'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['highest_qualification'] = this.highestQualification;
    data['area_of_specialization'] = this.areaOfSpecialization;
    data['professional_designation'] = this.professionalDesignation;
    data['professional_field'] = this.professionalField;
    data['office_name'] = this.officeName;
    data['biography'] = this.biography;
    data['_2fa'] = this.twoFactorAuth;
    return data;
  }
}
