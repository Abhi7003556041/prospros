import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prospros/widgets/custom_textformfield.dart';

class ResetWidget extends StatelessWidget {
  const ResetWidget({
    super.key,
    required this.formName,
    required this.controller,
    required this.validator,
    this.visibility,
    this.onPressed,
    this.isNotPassword = true,
  });
  final String formName;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? visibility;
  final bool isNotPassword;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formName),
        SizedBox(height: 8),
        CustomTextFormField(
          inputFormatters:
              isNotPassword ? null : [LengthLimitingTextInputFormatter(16)],
          obscureText: isNotPassword ? false : (!(visibility ?? true)),
          suffixIcon: isNotPassword
              ? null
              : IconButton(
                  icon: Icon(
                    (visibility ?? false)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    //color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: onPressed,
                ),
          validator: validator,
          labelTxt: formName,
          hintTxt: formName,
          controller: controller,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
