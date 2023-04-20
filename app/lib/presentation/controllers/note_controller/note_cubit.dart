import 'package:app/data/repositories/note_repository.dart';
import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/usecases/add_note_usecase.dart';
import 'package:app/domain/usecases/get_all_note_usecase.dart';
import 'package:app/domain/usecases/get_favourite_notes_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/note.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());
  BaseNoteRepository baseNoteRepository=GetIt.instance.get<NoteRepository>();

  List<Note> getAllNotes()
  {
     List<Note> allNotes=   GetAllNotesUseCase(baseNoteRepository: baseNoteRepository).execute();
    emit(AllNotesLoaded(allNotes: allNotes));
    print("we are notes");
    return allNotes;
  }
  List<Note> getFavouriteNotes()
  {
    List<Note> favouriteNotes=GetFavouriteNotesUseCase(baseNoteRepository: baseNoteRepository).execute();
    emit(FavouriteNotesLoaded(favouriteNotes: favouriteNotes));
    return favouriteNotes;
  }

  void addNote(Note note)
  {
    AddNoteUseCase(baseNoteRepository:baseNoteRepository ).execute(note);
  }











}
