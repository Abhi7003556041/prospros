import 'package:flutter/material.dart';

class SubCatButton extends StatefulWidget {
  SubCatButton(
      {super.key, required this.btnText, this.isSelected = false, this.onTap});
  final String btnText;
  bool isSelected;
  void Function()? onTap;

  @override
  State<SubCatButton> createState() => _SubCatButtonState();
}

class _SubCatButtonState extends State<SubCatButton> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.3))),
            child: Row(
              children: [
                Text(widget.btnText,
                    style: TextStyle(
                        color: widget.isSelected
                            ? const Color(0xff2643E5)
                            : Colors.black)),
              ],
            )),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.isSelected = !widget.isSelected;
              if (widget.onTap != null) {
                widget.onTap!();
              }
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ))
      ],
    );
  }
}
