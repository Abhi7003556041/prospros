class HomeModel {
  List<String>? countryId;
  List<String>? subCategoryId;
  int? categoryId;
  int page = 1;
  String? keyword = "";

  HomeModel(
      {this.countryId,
      this.subCategoryId,
      this.categoryId,
      this.keyword = "",
      required this.page});

  HomeModel.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id[]'];
    page = json['page'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countryId != null) {
      data['country_id'] = this.countryId;
    }
    if (this.categoryId != null) {
      data['category_id'] = this.categoryId.toString();
    }

    if (this.subCategoryId != null) {
      data['sub_category_id'] = this.subCategoryId;
    }

    data['page'] = page;
    data['keyword'] = keyword;
    return data;
  }
}
