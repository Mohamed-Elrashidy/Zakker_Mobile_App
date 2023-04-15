import 'package:app/presentation/widgets/category_widget.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_button.dart';
import 'package:app/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/category.dart';
import '../../utils/dimension_scale.dart';
import '../widgets/big_text.dart';

class CategoryPage extends StatelessWidget {
 late Dimension scaleDimension;
 List<Category> categoryList=DummyData.categories;
  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
            child: Column(
            children: [
              _appBarBuilder(),
              SizedBox(height: scaleDimension.scaleHeight(20),),
              _bodyBuilder()
            ],
          ),),
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
  
  Widget _bodyBuilder()
  {
    return Column(
      children: [
        Container(height: scaleDimension.scaleHeight(400),

          child: GridView.builder(gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: scaleDimension.scaleWidth(30),
            mainAxisSpacing: scaleDimension.scaleHeight(30),
            crossAxisCount: 2,
          ),itemCount: categoryList.length, itemBuilder: (context,index){
            return CategoryWidget(category: categoryList[index]);
          }),
        ),
        SizedBox(height: scaleDimension.scaleHeight(40),),
        NormalText(text: "You have ${categoryList.length} categories")
      ],
    );
  }

}
