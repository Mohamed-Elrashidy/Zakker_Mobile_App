import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/notes_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class TodaysNotesPage extends StatelessWidget {
  @override
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: GetIt.instance.get<Dimension>().scaleHeight(20),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back_ios)),
                BigText(text: "Today's Session"),
                SizedBox(width: GetIt.instance.get<Dimension>().scaleWidth(35),)
              ],
            ),
            SizedBox(height: GetIt.instance.get<Dimension>().scaleHeight(20),),
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if(state is TodaysNotesLoaded)
                  notes=state.todaysNotes;
                return Container(
                  padding: EdgeInsets.all(GetIt.instance.get<Dimension>().scaleWidth(10)),
                    height: GetIt.instance.get<Dimension>().scaleHeight(540), child: NotesListBuilder(notes: notes));
              },
            )
          ],
        ),
      ),
    );
  }

}

