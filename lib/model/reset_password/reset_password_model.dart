class ResetPasswordModel {
  String? email;
  String? otp;
  String? password;
  String? passwordConfirmation;

  ResetPasswordModel(
      {this.email, this.otp, this.password, this.passwordConfirmation});

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['otp'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otp'] = this.otp;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
