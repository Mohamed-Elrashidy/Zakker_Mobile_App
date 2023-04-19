import 'dart:convert';
import 'package:app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';

class LocalDataSource {
  final SharedPreferences sharedPreferences;
  LocalDataSource({required this.sharedPreferences});


  void addNote(NoteModel note) {
    List<NoteModel> allNotes = getAllNotes();
    allNotes.add(note);
    List<String> modifiedNotes = [];

    if (sharedPreferences.containsKey(AppConstants.notesList)) {
      modifiedNotes = sharedPreferences.getStringList(AppConstants.notesList)!;
      sharedPreferences.remove(AppConstants.notesList);
    }
    modifiedNotes.add(jsonEncode(note.toJson()));
    sharedPreferences.setStringList(AppConstants.notesList, modifiedNotes);
  }


  void editNote(NoteModel note) {

    List<String> modifiedNotes = [];
      modifiedNotes = sharedPreferences.getStringList(AppConstants.notesList)!;
      sharedPreferences.remove(AppConstants.notesList);

      // determine index of original note to replace it with new one
      int index=0;
      int noteIndex=-1;
      modifiedNotes.forEach((element) {
        NoteModel noteModel=NoteModel.fromJson(jsonDecode(element));
        if(noteModel.id==note.id) {
          noteIndex=index;

        }
        index++;
      });
      modifiedNotes[noteIndex]=jsonEncode(note.toJson());


      sharedPreferences.setStringList(AppConstants.notesList, modifiedNotes);
    }


  void deleteNote(int noteId) {

    List<String> modifiedNotes = [];
    modifiedNotes = sharedPreferences.getStringList(AppConstants.notesList)!;
    sharedPreferences.remove(AppConstants.notesList);

    // determine index of deleted note to remove it
    int index=0;
    int noteIndex=-1;
    modifiedNotes.forEach((element) {
      NoteModel noteModel=NoteModel.fromJson(jsonDecode(element));
      if(noteModel.id==noteId) {
        noteIndex=index;

      }
      index++;
    });

    modifiedNotes.removeAt(noteIndex);
    sharedPreferences.setStringList(AppConstants.notesList, modifiedNotes);
    deleteFromFavourites(noteId);
  }

  List<NoteModel> getAllNotes() {
    List<NoteModel> allNotes = [];
    if (sharedPreferences.containsKey(AppConstants.notesList)) {
      sharedPreferences.getStringList(AppConstants.notesList)
          ?.forEach((element) {
         allNotes.add(NoteModel.fromJson(jsonDecode(element)));
      });
    }

    return allNotes;
  }

  List<NoteModel> getFavouriteNotes() {
    Map<int, NoteModel> allNotes = {};
    List<NoteModel> favouriteNotes = [];
    List<int> favouriteNotesIds=[];
    if (sharedPreferences.containsKey(AppConstants.notesList)) {
      sharedPreferences.getStringList(AppConstants.notesList)
          ?.forEach((element) {
            NoteModel note=NoteModel.fromJson(jsonDecode(element));
         allNotes[note.id]=note;
      });
    }
    if(sharedPreferences.containsKey(AppConstants.favoriteList))
      {
        sharedPreferences.getStringList(AppConstants.favoriteList)?.forEach((element) {
          favouriteNotesIds.add(int.parse(element));
        });
      }

    for(int i=0;i<favouriteNotesIds.length;i++)
      {
        favouriteNotes.add(allNotes[favouriteNotesIds[i]]!);
      }

    return favouriteNotes;

  }


  void addToFavourites(int noteId) {


    List<String> favouriteNotesIds = [];
    if(sharedPreferences.containsKey(AppConstants.favoriteList))
    {
      sharedPreferences.getStringList(AppConstants.favoriteList)?.forEach((element) {
        favouriteNotesIds.add(element);
      });
      sharedPreferences.remove(AppConstants.favoriteList);
    }

    favouriteNotesIds.add(noteId.toString());
    sharedPreferences.setStringList(AppConstants.favoriteList, favouriteNotesIds);

  }


  void deleteFromFavourites(int noteId) {
    List<String> favouriteNotesIds = [];
    if(sharedPreferences.containsKey(AppConstants.favoriteList))
    {
      sharedPreferences.getStringList(AppConstants.favoriteList)?.forEach((element) {
        favouriteNotesIds.add(element);
      });
      sharedPreferences.remove(AppConstants.favoriteList);
    }

    favouriteNotesIds.remove(noteId.toString());
    sharedPreferences.setStringList(AppConstants.favoriteList, favouriteNotesIds);
  }

  void addCategory(CategoryModel category)
  {

  }


}
