import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/utils/dummy_data.dart';
import 'package:app/utils/note_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';
import '../../utils/routes.dart';
import '../widgets/small_text.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Dimension scaleDimension;

  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              _appBarBuilder(),
              _tabBarBuilder(),
              SizedBox(
                height: scaleDimension.scaleHeight(20),
              ),
              _bodyBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/notes_page_logo.svg",
                  semanticsLabel: 'Acme Logo',
                ),
                SizedBox(
                  width: scaleDimension.scaleWidth(10),
                ),
                BigText(text: "Your Notes")
              ],
            ),
            Spacer(),
            MainButton(title: "Add note", onTap: () {Navigator.of(context,rootNavigator: true).pushNamed(Routes.addNotePage);})
          ],
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
          width: scaleDimension.screenWidth,
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Container(
        height: scaleDimension.scaleHeight(400),
        child: ListView.builder(
          itemCount: DummyData.notes.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _noteWidgetBuilder(DummyData.notes[index]),
                SizedBox(
                  height: scaleDimension.scaleHeight(20),
                )
              ],
            );
          },
        ));
  }

  Widget _tabBarBuilder() {
    return Container(
      width: scaleDimension.screenWidth,
      height: scaleDimension.scaleHeight(50),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MainButton(
            title: "Notes",
            onTap: () {},
          ),
          MainButton(
            title: "Session",
            onTap: () {},
            buttonColor: Colors.grey[200]!,
            textColor: Colors.grey,
          ),
          MainButton(
            title: "Favourites",
            onTap: () {},
            buttonColor: Colors.grey[200]!,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _noteWidgetBuilder(Note note) {
    return GestureDetector(
      onDoubleTap: (){
        Navigator.of(context,rootNavigator: true).pushNamed(Routes.notePage,arguments:note);

      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: scaleDimension.scaleWidth(20),
            vertical: scaleDimension.scaleHeight(10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
            color: NoteColors.color[note.color]!.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(text: note.title),
            SizedBox(
              height: scaleDimension.scaleHeight(5),
            ),
            NormalText(
              text: note.body,
              maxline: 2,
              color: Colors.grey,
            ),
            SizedBox(
              height: scaleDimension.scaleHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallText(
                  text: note.category + ' | ' + note.source,
                  isBold: true,
                ),
                SmallText(
                  text: note.date,
                  isBold: true,
                ),
              ],
            )
          ],
        ),
      ),
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
