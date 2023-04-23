import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class SmallText extends StatelessWidget {

  final String text;
  late bool isBold;
   SmallText({required this.text,this.isBold=false});

  @override
  Widget build(BuildContext context) {
    Dimension scaleDimension = GetIt.instance.get<Dimension>();

    return Text(
      text,style: TextStyle(
      color:Colors.grey,
      fontWeight: isBold?FontWeight.bold:FontWeight.normal,
      fontSize: scaleDimension.scaleWidth(14)
    ),


    );
  }
}
