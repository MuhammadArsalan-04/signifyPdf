import 'package:flutter/material.dart';

extension SizedBoxExtension on BuildContext {
  SizedBox sizedBox({double width = 0.0, double height = 0.0}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

extension IntExtension on int {
  SizedBox get widthBox {
    return SizedBox(
      width: this.toDouble(),
    );
  }

  SizedBox get heightBox {
    return SizedBox(
      height: this.toDouble(),
    );
  }
}
