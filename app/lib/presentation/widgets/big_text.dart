import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../base.dart';
import '../../utils/dimension_scale.dart';

class BigText extends StatelessWidget {
  // Get the intialized instance of Dimension class to make ui scalable
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  final String text;
  double? size;
  bool arabic=false;
  Color color;
  BigText({required this.text, this.size,this.color=Colors.black}){
    arabic=isArabic(text);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 10000,
      textDirection: arabic?TextDirection.rtl:TextDirection.ltr,
      style: TextStyle(
        color: color,
          fontSize: size ?? scaleDimension.scaleWidth(22),
          fontWeight: size==null?FontWeight.bold:FontWeight.normal),
    );
  }
}
