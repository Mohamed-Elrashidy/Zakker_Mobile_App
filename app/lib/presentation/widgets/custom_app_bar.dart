import 'package:app/utils/dimension_scale.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'big_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  var onTap;
   CustomAppBar({required this.title,  this.onTap});
 Dimension scaleDimension =GetIt.instance.get<Dimension>();
  @override
  Widget build(BuildContext context) {
    return  Column(

      children: [
        SizedBox(height: scaleDimension.scaleHeight(20),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: onTap??() {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios)),
            Container(
                width: scaleDimension.scaleWidth(300),
                child: Center(child: BigText(text: title))),
            Container(
              width: scaleDimension.scaleWidth(40),
            )
          ],
        ),
        SizedBox(height: scaleDimension.scaleHeight(20),),

      ],
    );;
  }
}
