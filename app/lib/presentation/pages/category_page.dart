import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/widgets/category_widget.dart';
import 'package:app/presentation/widgets/dvider.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/category.dart';
import '../../utils/dimension_scale.dart';
import '../../utils/routes.dart';
import '../widgets/big_text.dart';

class CategoryPage extends StatelessWidget {
  late Dimension scaleDimension = GetIt.instance.get<Dimension>();
  late List<Category> categoryList;

  @override
  Widget build(BuildContext context) {
    categoryList = BlocProvider.of<CategoryCubit>(context).getAllCategories();
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText(text: "Categories"),
          ],
        ),

      ],
    );
  }

  Widget _bodyBuilder() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is GetAllCategories) {
          categoryList = state.allCategories;
        }
        return Column(
          children: [
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if(state is GetAllCategories)
                  categoryList=state.allCategories;
                return Container(
                  height: scaleDimension.scaleHeight(400),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: scaleDimension.scaleWidth(30),
                        mainAxisSpacing: scaleDimension.scaleHeight(30),
                        crossAxisCount: 2,
                      ),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(
                                  Routes.categorySourcesList,
                                  arguments: categoryList[index].title);
                            },
                            child: CategoryWidget(
                                category: categoryList[index]));
                      }),
                );
              },
            ),
            SizedBox(
              height: scaleDimension.scaleHeight(40),
            ),
            NormalText(text: "You have ${categoryList.length} categories")
          ],
        );
      },
    );
  }
}
