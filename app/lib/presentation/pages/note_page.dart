import '../../utils/routes.dart';

import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class NotePage extends StatelessWidget {
  final Note note;
  NotePage({required this.note});
  late Dimension scaleDimension;

  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _appBarBuilder(context),
                    SizedBox(
                      height: scaleDimension.scaleHeight(10),
                    ),
                    Container(
                        height: 2,
                        width: scaleDimension.screenWidth,
                        color: Colors.grey[400]),
                    _bodyBuilder(),
                    SizedBox(
                      height: scaleDimension.scaleHeight(10),
                    ),
                    _noteData(),
                  ],
                ),
              ))),
    );
  }

  Widget _appBarBuilder(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainButton(title: "Edit", onTap: () {

              Navigator.of(context,rootNavigator: true).pushNamed(Routes.editNotePage,arguments:note);

            }),
            MainButton(title: "Delete", onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(15),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: scaleDimension.scaleWidth(10)),
              child: BigText(text: note.title),
            ),
          ],
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
            height: 2,
            width: scaleDimension.screenWidth,
            color: Colors.grey[400]),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        NormalText(text: note.body)
      ],
    );
  }

  Widget _noteData() {
    return Row(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [
            BigText(
              text: "Note Data",
            ),
            SizedBox(height:
              scaleDimension.scaleHeight(20),),
            itemBuilder("category", note.category),
            itemBuilder("source", note.source),
            itemBuilder("page", note.page.toString()),



          ],
        ),
      ],
    );
  }
  Widget itemBuilder(String title,String info)
  {
    return SmallText(text:title+' : '+info);

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
