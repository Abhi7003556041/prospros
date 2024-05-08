class CommunityModel {
  String? searchKeyword;
  int? page;

  CommunityModel({this.searchKeyword, this.page = 1});

  CommunityModel.fromJson(Map<String, dynamic> json) {
    searchKeyword = json['search_keyword'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_keyword'] = this.searchKeyword;
    data['page'] = this.page;
    return data;
  }
}
