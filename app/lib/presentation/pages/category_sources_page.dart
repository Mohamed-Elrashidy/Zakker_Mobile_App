import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/widgets/category_widget.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/source.dart';
import '../../utils/dimension_scale.dart';
import '../widgets/big_text.dart';

class CategorySourcesPage extends StatelessWidget {
  late Dimension scaleDimension = GetIt.instance.get<Dimension>();
   List<Source> categorySourcesList=[];
  String category;
  int categoryId;
  CategorySourcesPage({required this.category, required this.categoryId});

  @override
  Widget build(BuildContext context) {
        BlocProvider.of<CategoryCubit>(context).getCategorySources(categoryId);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
            child: Column(
              children: [
                _appBarBuilder(context),
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

  Widget _appBarBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        Container(
            width: scaleDimension.scaleWidth(300),
            child: Center(child: BigText(text: category))),
        Container(
          width: scaleDimension.scaleWidth(40),
        )
      ],
    );
  }

  Widget _bodyBuilder() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is GetCategorySources) {
          categorySourcesList = state.allCategorySources;
          print("we are at get cater");
        }
        return Column(
          children: [
            Container(
              height: scaleDimension.scaleHeight(420),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: scaleDimension.scaleWidth(30),
                    mainAxisSpacing: scaleDimension.scaleHeight(30),
                    crossAxisCount: 2,
                    childAspectRatio: 0.85

                  ),
                  itemCount: categorySourcesList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      
                      columnCount: 2,
                      child: SlideAnimation
                        (
                        duration: Duration(milliseconds: 500),
                        verticalOffset: 0,
                        horizontalOffset: -300,
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  Routes.sourceNotesPage,
                                  arguments: category +
                                      '|' +
                                      categorySourcesList[index].title);
                            },
                            child: CategoryWidget(
                                category: categorySourcesList[index])),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: scaleDimension.scaleHeight(60),
            ),
            NormalText(text: "You have ${categorySourcesList.length} sources")
          ],
        );
      },
    );
  }
}
