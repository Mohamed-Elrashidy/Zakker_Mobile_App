
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/notes_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/note.dart';
import '../../utils/dimension_scale.dart';

class SourceNotesPage extends StatelessWidget {
  String source;
  String category;

  SourceNotesPage({required this.category,required this.source});
  late List<Note> notes;

  @override
  Widget build(BuildContext context) {
    notes= BlocProvider.of<NoteCubit>(context).getSourceNotes(category+source);
    return SafeArea(
        child: Scaffold(
            body: Column(
              children: [
                BigText(text: source),
                Container(height: GetIt.instance.get<Dimension>().scaleHeight(400),
                  child: BlocBuilder<NoteCubit,NoteState>(
                      builder: (context,state){
                        notes=BlocProvider.of<NoteCubit>(context).getSourceNotes(category+source);

                        return NotesListBuilder(notes: notes);
                      }),
                )
              ],
            )
        )
    );
  }
}
