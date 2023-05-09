import 'dart:io';
import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/routes.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';
import '../controllers/note_controller/note_cubit.dart';

class NotePage extends StatelessWidget {
  final Note note;
  bool isFavourite = false;

  NotePage({required this.note});

  Dimension scaleDimension = GetIt.instance.get<Dimension>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NoteCubit>(context).checkIsFavourite(note.id);
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          //    height: scaleDimension.scaleHeight(430),
                          child: _bodyBuilder(),
                        ),
                      ],
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
            MainButton(
                title: "Delete",
                onTap: () {
                  BlocProvider.of<NoteCubit>(context).deleteNote(note);
                  BlocProvider.of<NoteCubit>(context).getFavouriteNotes();
                  BlocProvider.of<NoteCubit>(context).getAllNotes();
                  BlocProvider.of<CategoryCubit>(context).getAllCategories();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.bottomNavBarPage, (route) => false);
                }),
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
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if (state is CheckIsFavourite) {
                  print("reached again");
                  isFavourite = state.isFavourite;
                }
                return IconButton(
                    onPressed: () {
                      if (isFavourite) {
                        BlocProvider.of<NoteCubit>(context)
                            .deleteFromFavourites(note.id);
                        isFavourite = false;
                      } else {
                        BlocProvider.of<NoteCubit>(context)
                            .addToFavourites(note.id);
                        isFavourite = true;
                      }

                      BlocProvider.of<NoteCubit>(context)
                          .checkIsFavourite(note.id);
                    },
                    icon: isFavourite
                        ? Icon(Icons.star,
                            color: Colors.yellow,
                            size: scaleDimension.scaleWidth(30))
                        : Icon(Icons.star_border,
                            size: scaleDimension.scaleWidth(30)));
              },
            )
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
        ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: note.image != ""
                  ? scaleDimension.scaleHeight(190)
                  : scaleDimension.scaleHeight(350),
            ),
            child: NormalText(text: note.body)),
        SizedBox(
          height: scaleDimension.scaleWidth(20),
        ),
      ],
    );
  }

  Widget _noteData() {
    return Column(
      children: [
        (note.image.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.transparent,
                ),
                width:scaleDimension.scaleWidth(250),
                height: scaleDimension.scaleWidth(250),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.file(
                    File(note.image),
                    fit: BoxFit.cover,
                  ),
                ))
            : Container(),
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        ),
        Row(
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
                _itemBuilder("category", note.category),
                _itemBuilder("source", note.source),
                _itemBuilder("page", note.page.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _itemBuilder(String title, String info) {
    return Row(
      children: [
        SmallText(text: title + ' : ' ),
        SmallText(text: info)
      ],
    );
  }
}
