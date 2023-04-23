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
  Dimension scaleDimension = GetIt.instance.get<Dimension>();

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      height: scaleDimension.scaleHeight(430),
                      child: _bodyBuilder(),
                    ),
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
            MainButton(
                title: "Edit",
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.editNotePage, arguments: note);
                }),
            MainButton(title: "Delete", onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: scaleDimension.scaleHeight(15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: scaleDimension.scaleWidth(10)),
                child: SizedBox(
                    width: scaleDimension.screenWidth -
                        scaleDimension.scaleWidth(85),
                    child: BigText(text: note.title)),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.star_border,
                    size: scaleDimension.scaleWidth(30),
                  ))
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
      ),
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
            SizedBox(
              height: scaleDimension.scaleHeight(20),
            ),
            itemBuilder("category", note.category),
            itemBuilder("source", note.source),
            itemBuilder("page", note.page.toString()),
          ],
        ),
      ],
    );
  }

  Widget itemBuilder(String title, String info) {
    return SmallText(text: title + ' : ' + info);
  }
}
