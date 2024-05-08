bool validateEmail(String? value) {
  if (value != null &&
      value.length > 5 &&
      value.contains('@') &&
      value.endsWith('.com')) {
    return false;
  }
  return true;
  //return 'Enter a Valid Email Address';
}

bool passwordValidator(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty) return true;
  //return '*Please fill in this required field';
  if (!regExp.hasMatch(value.trim()))
    // return '*Enter a valid Password';
    return true;
  else
    return false;
  //return null;
}

String? validator(String? value, String message) {
  if (value!.isEmpty) {
    return message;
  }

  return null;
}
