import 'package:app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class MainButton extends StatelessWidget {
  final Function onTap;
  final String title;
  MainButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Dimension scaleDimension = GetIt.instance.get<Dimension>();
    return IntrinsicWidth(
      stepWidth: 100,
      child: Container(
        //width: scaleDimension.scaleWidth(170),
        decoration: BoxDecoration(
            color: MyColors.black,
            borderRadius: BorderRadius.circular(scaleDimension.scaleHeight(16))),
        padding: EdgeInsets.symmetric(
            horizontal: scaleDimension.scaleWidth(10),
            vertical: scaleDimension.scaleHeight(7)),
        child: Center(
          child: Text(title,style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: scaleDimension.scaleWidth(22),
              color:MyColors.white
          )),
        ),
      ),
    );
  }
}
