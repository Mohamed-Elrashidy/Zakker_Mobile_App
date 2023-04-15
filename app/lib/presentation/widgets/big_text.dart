import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class BigText extends StatelessWidget {
  // Get the intialized instance of Dimension class to make ui scalable
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  final String text;
  double? size;
  BigText({required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? scaleDimension.scaleWidth(22),
          fontWeight: size==null?FontWeight.bold:FontWeight.normal),
    );
  }
}
