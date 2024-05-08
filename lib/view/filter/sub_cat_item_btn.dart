import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubCatItemButton extends StatefulWidget {
  SubCatItemButton(
      {super.key, required this.btnText, this.isSelected = false, this.onTap});
  final String btnText;
  bool isSelected;
  void Function()? onTap;

  @override
  State<SubCatItemButton> createState() => _SubCatItemButtonState();
}

class _SubCatItemButtonState extends State<SubCatItemButton> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.btnText,
                      style: TextStyle(
                          color: widget.isSelected
                              ? Color(0xff2643E5)
                              : Colors.black)),
                ),
                widget.isSelected
                    ? Animate(
                        effects: const [
                          ShimmerEffect(
                              duration: Duration(milliseconds: 700),
                              colors: [Color(0xff2643E5), Colors.white])
                        ],
                        child: const Icon(
                          Icons.check,
                          color: Color(0xff2643E5),
                          size: 15,
                        ),
                      )
                    : SizedBox()
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
