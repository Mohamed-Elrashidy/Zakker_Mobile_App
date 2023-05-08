
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
   List<Note> notes=[];

  @override
  Widget build(BuildContext context) {
    print("category is => $category");
    print("source is => $source");

    BlocProvider.of<NoteCubit>(context).getSourceNotes(category+source);
    return SafeArea(
        child: Scaffold(
            body: Column(
              children: [
                SizedBox(height: GetIt.instance.get<Dimension>().scaleHeight(10),),

                _appBarBuilder(context),
                SizedBox(height: GetIt.instance.get<Dimension>().scaleHeight(20),),
                Container(height: GetIt.instance.get<Dimension>().scaleHeight(400),
                  child: BlocBuilder<NoteCubit,NoteState>(
                      builder: (context,state){
                      if(state is SourceNotesLoaded)
                        notes =state.sourceNotesList;
                        return Padding(
                          padding: EdgeInsets.all(GetIt.instance.get<Dimension>().scaleWidth(10)),
                          child: NotesListBuilder(notes: notes),
                        );
                      }),
                )
              ],
            )
        )
    );
  }
 Widget _appBarBuilder(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new)),
        Container(
            width: GetIt.instance.get<Dimension>().scaleWidth(300),
            child: Center(child: BigText(text: source),)),
        Container(width: GetIt.instance.get<Dimension>().scaleWidth(40),)

      ],
    );
  }
}
