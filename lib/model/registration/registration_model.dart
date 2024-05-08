// {
//     "name" : "Alex",
//     "email" : "alex@yopmail.com",
//     "password" : "12345678",
//     "c_password" : "12345678",
//     "contact_number" : "1234567890",
//     "country_id" : "101"
// }

class RegistrationModel {
  String? name;
  String? email;
  String? password;
  String? cPassword;
  String? contactNumber;
  String? countryId;
  String? phoneCode;

  RegistrationModel(
      {this.name,
      this.email,
      this.password,
      this.cPassword,
      this.contactNumber,
      this.phoneCode,
      this.countryId});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    cPassword = json['c_password'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    phoneCode = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['c_password'] = this.cPassword;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['phone_code'] = this.phoneCode;
    return data;
  }
}
