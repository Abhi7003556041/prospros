import 'package:flutter/material.dart';
import 'package:prospros/widgets/pincode_verification_screen.dart';

class EmailVerification extends StatelessWidget {
  EmailVerification(
      {Key? key, this.onVerificationCompleted, required this.email})
      : super(key: key);

  ///this callback has been used to verify email while login ; if hasn't verified email while registering. Don't provide it while swithing user to this screen from register page
  VoidCallback? onVerificationCompleted;
  final String email;
  @override
  Widget build(BuildContext context) {
    return PinCodeVerificationScreen(
      onVerificationCompleted: onVerificationCompleted,
      email: email,
    );
  }
}
