import 'dart:convert';
import 'package:app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';

class LocalDataSource {
  final SharedPreferences sharedPreferences;
  LocalDataSource({required this.sharedPreferences}) {
    if (sharedPreferences.containsKey(AppConstants.newId))
      sharedPreferences.setInt(AppConstants.newId, 0);
  }
  int generateId() {
    int newId = sharedPreferences.getInt(AppConstants.newId)??0;
    sharedPreferences.remove(AppConstants.newId);
    sharedPreferences.setInt(AppConstants.newId, newId + 1);
    return newId;
  }

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
    int index = 0;
    int noteIndex = -1;
    modifiedNotes.forEach((element) {
      NoteModel noteModel = NoteModel.fromJson(jsonDecode(element));
      if (noteModel.id == note.id) {
        noteIndex = index;
      }
      index++;
    });
    modifiedNotes[noteIndex] = jsonEncode(note.toJson());

    sharedPreferences.setStringList(AppConstants.notesList, modifiedNotes);
  }

  void deleteNote(NoteModel note) {
    List<String> modifiedNotes = [];
    modifiedNotes = sharedPreferences.getStringList(AppConstants.notesList)!;
    sharedPreferences.remove(AppConstants.notesList);

    // determine index of deleted note to remove it
    int index = 0;
    int noteIndex = -1;
    modifiedNotes.forEach((element) {
      NoteModel noteModel = NoteModel.fromJson(jsonDecode(element));
      if (noteModel.id == note.id) {
        noteIndex = index;
      }
      index++;
    });

    modifiedNotes.removeAt(noteIndex);
    sharedPreferences.setStringList(AppConstants.notesList, modifiedNotes);
    deleteFromCategory(note.category);
    deleteFromSource(note.category, note.source);
    deleteFromFavourites(note.id);
  }

  List<NoteModel> getAllNotes() {
    List<NoteModel> allNotes = [];
    if (sharedPreferences.containsKey(AppConstants.notesList)) {
      sharedPreferences
          .getStringList(AppConstants.notesList)
          ?.forEach((element) {
        allNotes.add(NoteModel.fromJson(jsonDecode(element)));
      });
    }

    return allNotes;
  }

  List<NoteModel> getFavouriteNotes() {
    Map<int, NoteModel> allNotes = {};
    List<NoteModel> favouriteNotes = [];
    List<int> favouriteNotesIds = [];
    if (sharedPreferences.containsKey(AppConstants.notesList)) {
      sharedPreferences
          .getStringList(AppConstants.notesList)
          ?.forEach((element) {
        NoteModel note = NoteModel.fromJson(jsonDecode(element));
        allNotes[note.id] = note;
      });
    }
    if (sharedPreferences.containsKey(AppConstants.favoriteList)) {
      sharedPreferences
          .getStringList(AppConstants.favoriteList)
          ?.forEach((element) {
        favouriteNotesIds.add(int.parse(element));
      });
    }

    for (int i = 0; i < favouriteNotesIds.length; i++) {
      favouriteNotes.add(allNotes[favouriteNotesIds[i]]!);
    }

    return favouriteNotes;
  }

  void addToFavourites(int noteId) {
    List<String> favouriteNotesIds = [];
    if (sharedPreferences.containsKey(AppConstants.favoriteList)) {
      sharedPreferences
          .getStringList(AppConstants.favoriteList)
          ?.forEach((element) {
        favouriteNotesIds.add(element);
      });
      sharedPreferences.remove(AppConstants.favoriteList);
    }

    favouriteNotesIds.add(noteId.toString());
    sharedPreferences.setStringList(
        AppConstants.favoriteList, favouriteNotesIds);
  }

  void deleteFromFavourites(int noteId) {
    List<String> favouriteNotesIds = [];
    if (sharedPreferences.containsKey(AppConstants.favoriteList)) {
      sharedPreferences
          .getStringList(AppConstants.favoriteList)
          ?.forEach((element) {
        favouriteNotesIds.add(element);
      });
      sharedPreferences.remove(AppConstants.favoriteList);
    }

    favouriteNotesIds.remove(noteId.toString());
    sharedPreferences.setStringList(
        AppConstants.favoriteList, favouriteNotesIds);
  }

  void addToCategory(String category, int color) {
    List<String> allCategories = [];
    String key = AppConstants.categoryList;
    bool exist = false;

    if (sharedPreferences.containsKey(key)) {
      allCategories = sharedPreferences.getStringList(key)!;
      sharedPreferences.remove(key);
    }
    for (int i = 0; i < allCategories.length; i++) {
      CategoryModel currentCategory =
          CategoryModel.fromJson(jsonDecode(allCategories[i]));
      if (currentCategory.title == category) {
        exist = true;
        currentCategory.numberOfNotes++;
        allCategories[i] = jsonEncode(currentCategory.toJson());
      }
    }
    if (!exist) {
      allCategories.add(jsonEncode(CategoryModel(
          title: category,
          color: color,
          numberOfNotes: 1,
          isSource: false,
          isCategory: true)));
    }

    sharedPreferences.setStringList(key, allCategories);
  }

  void addSource(String category, String source, int color) {
    bool exist = false;
    List<String> sources = [];
    if (sharedPreferences.containsKey(category)) {
      sources = sharedPreferences.getStringList(category)!;
      sharedPreferences.remove(category);
    }
    for (int i = 0; i < sources.length; i++) {
      CategoryModel categoryModel =
          CategoryModel.fromJson(jsonDecode(sources[i]));
      if (categoryModel.title == source) {
        exist = true;
        categoryModel.numberOfNotes++;
        sources[i] = jsonEncode(categoryModel.toJson());
      }
    }
    if (!exist) {
      CategoryModel categoryModel = CategoryModel(
          title: source,
          color: color,
          numberOfNotes: 1,
          isSource: true,
          isCategory: false);
      sources.add(jsonEncode(categoryModel.toJson()));
    }
    sharedPreferences.setStringList(category, sources);
  }

  void deleteFromCategory(String category) {
    List<String> allCategories = [];
    String key = AppConstants.categoryList;

    if (sharedPreferences.containsKey(key)) {
      allCategories = sharedPreferences.getStringList(key)!;
      sharedPreferences.remove(key);
    }
    for (int i = 0; i < allCategories.length; i++) {
      CategoryModel currentCategory =
          CategoryModel.fromJson(jsonDecode(allCategories[i]));
      if (currentCategory.title == category) {
        currentCategory.numberOfNotes--;
        allCategories[i] = jsonEncode(currentCategory.toJson());

        if (currentCategory.numberOfNotes == 0) {
          allCategories.removeAt(i);
        }
        break;
      }
    }

    sharedPreferences.setStringList(key, allCategories);
  }

  void deleteFromSource(String category, String source) {
    List<String> allSources = [];

    if (sharedPreferences.containsKey(category)) {
      allSources = sharedPreferences.getStringList(category)!;
      sharedPreferences.remove(category);
    }
    for (int i = 0; i < allSources.length; i++) {
      CategoryModel currentSource =
          CategoryModel.fromJson(jsonDecode(allSources[i]));
      if (currentSource.title == category) {
        currentSource.numberOfNotes--;
        allSources[i] = jsonEncode(currentSource.toJson());
        if (currentSource.numberOfNotes == 0) {
          allSources.removeAt(i);
        }
        break;
      }
    }

    sharedPreferences.setStringList(category, allSources);
  }

  List<CategoryModel> getAllCategories() {
    List<CategoryModel> allCategories = [];
    if (sharedPreferences.containsKey(AppConstants.categoryList)) {
      sharedPreferences
          .getStringList(AppConstants.categoryList)
          ?.forEach((element) {
        allCategories.add(CategoryModel.fromJson(jsonDecode(element)));
      });
    }
    return allCategories;
  }

  List<CategoryModel> getAllSources(String category) {
    List<CategoryModel> allSources = [];
    if (sharedPreferences.containsKey(category)) {
      sharedPreferences.getStringList(category)?.forEach((element) {
        allSources.add(CategoryModel.fromJson(jsonDecode(element)));
      });
    }

    return allSources;
  }
}
