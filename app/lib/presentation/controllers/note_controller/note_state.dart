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


