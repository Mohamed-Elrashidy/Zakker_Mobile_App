import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../base.dart';
import '../../utils/dimension_scale.dart';

class SmallText extends StatelessWidget {

  final String text;
  late bool isBold;
  bool arabic=false;
  Color color;
   SmallText({required this.text,this.isBold=false,this.color=Colors.grey}){
     arabic=isArabic(text);
   }

  @override
  Widget build(BuildContext context) {
    Dimension scaleDimension = GetIt.instance.get<Dimension>();

    return Text(

      text,
overflow: TextOverflow.ellipsis,
      style: TextStyle(

      color:color,
      fontWeight: isBold?FontWeight.bold:FontWeight.normal,
      fontSize: scaleDimension.scaleWidth(14)

    ),
textDirection: arabic?TextDirection.rtl:TextDirection.ltr,

    );
  }
}
