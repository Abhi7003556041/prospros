class ChangePasswordModel {
  String? oldPassword;
  String? password;
  String? passwordConfirmation;

  ChangePasswordModel(
      {this.oldPassword, this.password, this.passwordConfirmation});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    oldPassword = json['old_password'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.oldPassword;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
