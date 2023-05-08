import 'package:animate_do/animate_do.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import '../../base.dart';
import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';
import '../../utils/note_colors.dart';
import '../../utils/routes.dart';
import 'big_text.dart';
import 'normal_text.dart';

class NotesListBuilder extends StatelessWidget {
  List<Note> notes;
  NotesListBuilder({required this.notes});
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    AnimationController animateController;

    print("rebuilded");
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        print("$index");
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 0,
            horizontalOffset: -500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _noteWidgetBuilder(notes[index], context),
                SizedBox(
                  height: scaleDimension.scaleHeight(20),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _noteWidgetBuilder(Note note, BuildContext context) {
    bool arabic = isArabic(note.title);
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(Routes.notePage, arguments: note);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: scaleDimension.scaleWidth(20),
            vertical: scaleDimension.scaleHeight(10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
            color: NoteColors.color[note.color]!.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment:
              (arabic) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            arabic
                ? arabicRow('${note.category} | ${note.source}', note.date)
                : englishRow('${note.category} | ${note.source}', note.date)
          ],
        ),
      ),
    );
  }

  Widget arabicRow(String data, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            child: SmallText(
          text: date.substring(0, 10),
          isBold: true,
        )),
        SizedBox(
          width: scaleDimension.scaleWidth(250),
          child: SmallText(
            text: data,
            isBold: true,
          ),
        ),
      ],
    );
  }

  Widget englishRow(String data, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: scaleDimension.scaleWidth(250),
          child: SmallText(
            text: data,
            isBold: true,
          ),
        ),
        SizedBox(
            child: SmallText(
          text: date.substring(0, 10),
          isBold: true,
        )),
      ],
    );
  }
}
