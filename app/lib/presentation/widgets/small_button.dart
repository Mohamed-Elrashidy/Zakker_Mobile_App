import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class SmallButton extends StatelessWidget {
  final IconData icon;
  final  onTap;
   SmallButton({required this.icon,required this.onTap});
  Dimension scaleDimension=GetIt.instance.get<Dimension>();
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed:onTap, icon: Icon(icon,size:scaleDimension.scaleWidth(30),),);
  }
}
