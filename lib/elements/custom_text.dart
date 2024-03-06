import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  double? fontSize;
  Color? textColor;
  FontWeight? fontWeight;
  bool softwrap;

  CustomText({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.softwrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softwrap,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
