import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/widgets/category_widget.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_button.dart';
import 'package:app/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/category.dart';
import '../../utils/dimension_scale.dart';
import '../widgets/big_text.dart';

class CategorySourcesPage extends StatelessWidget {
  late Dimension scaleDimension = GetIt.instance.get<Dimension>();
  late List<Category> categorySourcesList;
  String category;
  CategorySourcesPage({required this.category});

  @override
  Widget build(BuildContext context) {
    categorySourcesList = BlocProvider.of<CategoryCubit>(context).getCategorySources(category);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
            child: Column(
              children: [
                _appBarBuilder(),
                SizedBox(
                  height: scaleDimension.scaleHeight(20),
                ),
                _bodyBuilder()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: scaleDimension.scaleWidth(35)),
        BigText(text: "Categories"),
        SmallButton(icon: Icons.add_circle_outline_outlined, onTap: () {})
      ],
    );
  }


  Widget _bodyBuilder() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if(state is GetCategorySources)
        {
          categorySourcesList=state.allCategorySources;
        }
        return Column(
          children: [
            Container(
              height: scaleDimension.scaleHeight(400),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: scaleDimension.scaleWidth(30),
                    mainAxisSpacing: scaleDimension.scaleHeight(30),
                    crossAxisCount: 2,
                  ),
                  itemCount: categorySourcesList.length,
                  itemBuilder: (context, index) {
                    return CategoryWidget(category: categorySourcesList[index]);
                  }),
            ),
            SizedBox(
              height: scaleDimension.scaleHeight(40),
            ),
            NormalText(text: "You have ${categorySourcesList.length} categories")
          ],
        );
      },
    );
  }
}
