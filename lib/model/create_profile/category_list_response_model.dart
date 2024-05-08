class CategoryList {
  bool? success;
  List<CategoryData>? data;
  String? message;

  CategoryList({this.success, this.data, this.message});

  CategoryList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CategoryData {
  int? id;
  String? categoryName;
  List<SubcatagoryList>? subcatagoryList;

  CategoryData({this.id, this.categoryName, this.subcatagoryList});

  CategoryData.fromJson(Map<String, dynamic> json) {
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
  bool? isSelected;

  SubcatagoryList({this.id, this.categoryName, this.isSelected});

  SubcatagoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}
