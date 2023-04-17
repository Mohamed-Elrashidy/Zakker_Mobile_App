import 'package:app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class NormalText extends StatelessWidget {
  final String text;
  late int maxline;
  late Color color;
  NormalText(
      {required this.text, this.maxline = 10000, this.color = Colors.black});
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxline,
      style: TextStyle(fontSize: scaleDimension.scaleWidth(18), color: color),
    );
  }
}
