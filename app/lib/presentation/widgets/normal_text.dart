import 'package:app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class NormalText extends StatelessWidget {
  final String text;
   NormalText({required this.text});
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: scaleDimension.scaleWidth(18),
      color: MyColors.black
    ),);
  }
}
