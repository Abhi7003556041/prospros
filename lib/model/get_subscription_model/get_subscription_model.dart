class GetSubscriptionModel {
  int? subscriptionId;

  GetSubscriptionModel({this.subscriptionId});

  GetSubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_id'] = this.subscriptionId;
    return data;
  }
}
