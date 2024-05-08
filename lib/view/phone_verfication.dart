import 'package:flutter/material.dart';
import 'package:prospros/widgets/pincode_verification_screen.dart';

class PhoneVerification extends StatelessWidget {
  PhoneVerification(
      {Key? key, this.onVerificationCompleted, this.phone, this.countryCode})
      : super(key: key);

  ///this callback has been used to verify phone while login ; if hasn't verified phone while registering. Don't provide it while swithing user to this screen from register page
  VoidCallback? onVerificationCompleted;
  final String? phone;
  final String? countryCode;
  @override
  Widget build(BuildContext context) {
    return PinCodeVerificationScreen(
      isEmail: false,
      onVerificationCompleted: onVerificationCompleted,
      phone: phone,
      countryCode: countryCode,
    );
  }
}
