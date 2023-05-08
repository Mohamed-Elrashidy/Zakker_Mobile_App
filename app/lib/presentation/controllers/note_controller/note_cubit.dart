import 'package:app/data/repositories/note_repository.dart';
import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/usecases/add_note_usecase.dart';
import 'package:app/domain/usecases/add_to_favourites_usecase.dart';
import 'package:app/domain/usecases/delete_from_favourites_usecase.dart';
import 'package:app/domain/usecases/edit_note_usecase.dart';
import 'package:app/domain/usecases/get_all_note_usecase.dart';
import 'package:app/domain/usecases/get_favourite_notes_usecase.dart';
import 'package:app/domain/usecases/get_todays_notes_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/delete_note_usecase.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {

  NoteCubit() : super(NoteInitial());
  BaseNoteRepository baseNoteRepository = GetIt.instance.get<NoteRepository>();
  Map<String, List<Note>> sourcesNotes = {};
  clearNotes()
  {
    emit(ClearNotes());
  }

  Future<List<Note>>_getAllNotes()
  async {
    sourcesNotes = {};
    List<Note> allNotes =
        await GetAllNotesUseCase(baseNoteRepository: baseNoteRepository)
        .execute();

    print("we are notes");

    for (int i = 0; i < allNotes.length; i++) {
      if (sourcesNotes.containsKey(allNotes[i].category + allNotes[i].source))
        sourcesNotes[allNotes[i].category + allNotes[i].source]
            ?.add(allNotes[i]);
      else {
        print("one of keys is => "+ allNotes[i].category + allNotes[i].source);
        sourcesNotes.putIfAbsent(
            allNotes[i].category + allNotes[i].source, () => [allNotes[i]]);
      }
    }

    return allNotes;

  }
  Future<List<Note>> getAllNotes() async {
    List<Note>allNotes= await  _getAllNotes();
    emit(AllNotesLoaded(allNotes: allNotes));
    return allNotes;
  }

  Future<List<Note>> getSourceNotes(String key) async {

    await _getAllNotes();
    print(sourcesNotes[key].toString());
    print("keyis => $key");
    emit(SourceNotesLoaded(sourceNotesList: sourcesNotes[key] ?? []));
    return sourcesNotes[key] ?? [];
  }

  Future<List<Note>> getTodaysNotes() async {
    List<Note> todaysNotes =
        await GetTodaysNotesUseCase(baseNoteRepository: baseNoteRepository)
            .execute();
    emit(TodaysNotesLoaded(todaysNotes: todaysNotes));
    return todaysNotes;
  }

  Future<List<Note>> getFavouriteNotes() async {
    List<Note> favouriteNotes =
        await GetFavouriteNotesUseCase(baseNoteRepository: baseNoteRepository)
            .execute();
    emit(FavouriteNotesLoaded(favouriteNotes: favouriteNotes));
    print("reached to favourites");
    return favouriteNotes;
  }

  Future<bool> checkIsFavourite(int noteId) async {
    bool isFavourite = false;
    List<Note> favouriteNotes =
        await GetFavouriteNotesUseCase(baseNoteRepository: baseNoteRepository)
            .execute();

    for (var element in favouriteNotes) {
      if (element.id == noteId) isFavourite = true;
    }

    emit(CheckIsFavourite(isFavourite: isFavourite));
    return false;
  }

  Future<void> addNote(Note note) async {
   await AddNoteUseCase(baseNoteRepository: baseNoteRepository).execute(note);
  }

  void deleteNote(Note note) {
    DeleteNoteUsCase(baseNoteRepository: baseNoteRepository).execute(note);
  }

  void editNote(Note note) {
    EditNoteUseCase(baseNoteRepository: baseNoteRepository).execute(note);
  }

  void addToFavourites(int noteId) {
    AddToFavouritesUseCase(baseNoteRepository: baseNoteRepository)
        .execute(noteId);
  }

  void deleteFromFavourites(int noteId) {
    DeleteFromFavouritesUseCase(baseNoteRepository: baseNoteRepository)
        .execute(noteId);
  }
}
