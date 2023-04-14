
import 'package:flutter/material.dart';

class Dimension{
  BuildContext context;
  late double screenHeight;
  late double screenWidth;
  Dimension({required this.context}){
     screenHeight=MediaQuery.of(context).size.height;
     screenWidth=MediaQuery.of(context).size.width-scaleWidth(20);
  }
//642

   double scaleHeight(double h)
  {
    double y=650.0/h;
    return screenHeight/y;
  }
    double scaleWidth(double w)
  {
    double y=410.0/w;
    return screenWidth/y;
  }
}