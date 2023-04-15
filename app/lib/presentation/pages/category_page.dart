import 'package:app/presentation/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';
import '../widgets/big_text.dart';

class CategoryPage extends StatelessWidget {
 late Dimension scaleDimension;
  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _appBarBuilder()
            ],
          ),
        ),
      ),
    );
  }
  Widget _appBarBuilder()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width:scaleDimension.scaleWidth(35)),
        BigText(text: "Categories"),
        SmallButton(icon: Icons.add_circle_outline_outlined, onTap: (){})
      ],
    );
  }
  dimensionInit(BuildContext context) {
    try {
      // Get the intialized instance of Dimension class to make ui scalable

      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    } catch (e) {
      GetIt locator = GetIt.instance;
      locator.registerSingleton<Dimension>(Dimension(context: context));

      // Get the initialized instance of Dimension class to make ui scalable
      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    }
  }


}
