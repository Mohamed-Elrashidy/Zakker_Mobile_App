part of 'note_cubit.dart';

@immutable
abstract class NoteState {}

class NoteInitial extends NoteState {}

class AllNotesLoaded extends NoteState{
  List<Note> allNotes;
  AllNotesLoaded({required this.allNotes});
}
class FavouriteNotesLoaded extends NoteState{
  List<Note> favouriteNotes;
  FavouriteNotesLoaded({required this.favouriteNotes});
}
class CheckIsFavourite extends NoteState{
  bool isFavourite;
  CheckIsFavourite({required this.isFavourite});
}
class SourceNotesLoaded extends NoteState{
  List<Note> sourceNotesList;
  SourceNotesLoaded({required this.sourceNotesList});
}
class TodaysNotesLoaded extends NoteState{
  List<Note> todaysNotes;
  TodaysNotesLoaded({required this.todaysNotes});
}
class ClearNotes extends NoteState{

}


