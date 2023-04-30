import 'package:animate_do/animate_do.dart';
import 'package:app/presentation/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  List<Note>_notes=[];

  @override
  Widget build(BuildContext context) {

    print("rebuilded");
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        print("$index");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(child: SlideInLeft(child: _noteWidgetBuilder(notes[index], context))),
            SizedBox(
              height: scaleDimension.scaleHeight(20),
            )
          ],
        );
      },
    );
  }

  Widget _noteWidgetBuilder(Note note, BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
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
                SizedBox(
                  width: scaleDimension.scaleWidth(250),
                  child: SmallText(
                    text: '${note.category} | ${note.source}',
                    isBold: true,
                  ),
                ),
                SizedBox(
                  child: SmallText(
                    text: note.date.substring(0, 10),
                    isBold: true,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
