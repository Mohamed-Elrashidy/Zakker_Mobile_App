import 'package:app/utils/dimension_scale.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Dvider extends StatelessWidget {
  const Dvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: Colors.grey,
      width: GetIt.instance.get<Dimension>().screenWidth-GetIt.instance.get<Dimension>().scaleWidth(20),
    );
  }
}
