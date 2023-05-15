import 'package:app/data/data_source/local_data_source/local_data_source_sqlflite.dart';
import 'package:app/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:app/utils/app_constants.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';
import '../domain/entities/note.dart';

class SyncService {
  LocalDataSource localDataSource;
  RemoteDataSource remoteDataSource;
  NoteRepository noteRepository;
  SyncService(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.noteRepository});
  Future<void> syncData() async {
    await updateRemoteData();
    await updateLocalData();
  }

  Future<void> updateRemoteData() async {
    // add new notes
    List<int> newNotesIds = await getIds(AppConstants.addedNotes);
    await pushNewNotes(newNotesIds);
    // delete notes
    List<int> deletedNotesIds = await getIds(AppConstants.deletedNotes);
    await deleteNotes(deletedNotesIds);
    //edit notes
    List<int> editedNotesIds = await getIds(AppConstants.editedList);
    await editNotes(editedNotesIds);
    // add favourites
    List<int> favouriteNotes = await getIds(AppConstants.addToFavourites);
    await pushNewFavourites(favouriteNotes);
    // delete favourites
    List<int> deletedFavouriteNotes =
        await getIds(AppConstants.deletedFromFavourites);
    await deleteFavourties(deletedFavouriteNotes);
  }

  pushNewFavourites(List<int> favouriteNotes) async {
    for (int i = 0; i < favouriteNotes.length; i++) {
      // Map<String, dynamic> note = await noteRepository.getNote(favouriteNotes[i]);
      //  print("this is the id => " + note['id'].toString());
      try {
        await remoteDataSource.addData(AppConstants.favouritesPath,
            favouriteNotes[i], {'id': favouriteNotes[i]});
      } catch (e) {
        print("error at adding to Favourites to firebase => " + e.toString());
      }
    }
    localDataSource.deleteAllTable(AppConstants.addToFavourites);
  }

  editNotes(List<int> editedNotesIds) async {
    for (int i = 0; i < editedNotesIds.length; i++) {
      Map<String, dynamic> note =
          await noteRepository.getNote(editedNotesIds[i]);
      try {
        await remoteDataSource.updateData(
            AppConstants.notesPath, note['id'], note);
      } catch (e) {
        print("error at editing notes to firebase => " + e.toString());
      }
    }
    localDataSource.deleteAllTable(AppConstants.editedList);
  }

  deleteFavourties(List<int> deletedFavouritesIds) async {
    print("deleted favourites =>" + deletedFavouritesIds.toString());
    for (int id in deletedFavouritesIds) {
      await remoteDataSource.deleteData(AppConstants.favouritesPath, id);
    }
    localDataSource.deleteAllTable(AppConstants.deletedFromFavourites);
  }

  deleteNotes(List<int> deletedNotesIds) async {
    for (int id in deletedNotesIds) {
      await remoteDataSource.deleteData(AppConstants.notesPath, id);
    }
    localDataSource.deleteAllTable(AppConstants.deletedNotes);
  }

  pushNewNotes(List<int> notesIds) async {
    for (int i = 0; i < notesIds.length; i++) {
      Map<String, dynamic> note = await noteRepository.getNote(notesIds[i]);
      print("this is the id => " + note['id'].toString());
      try {
        await remoteDataSource.addData(
            AppConstants.notesPath, note['id'], note);
      } catch (e) {
        print("error at adding notes to firebase => " + e.toString());
      }
    }
    localDataSource.deleteAllTable(AppConstants.addedNotes);
  }

  Future<List<int>> getIds(String tableName) async {
    List<int> ids = [];
    List<Map<String, dynamic>> temp = await localDataSource.getTable(tableName);
    for (int i = 0; i < temp.length; i++) {
      ids.add(temp[i]['id']);
    }

    return ids;
  }

  Future<void> updateLocalData() async {
    await updateLocalNotes();
    await updateLocalFavourites();
  }
   updateLocalFavourites()
   async {
     Map<int, int> remoteData =
         await getRemoteData<int>(AppConstants.favouritesPath);
     print("remote favourites is =>" + remoteData.toString());
     Map<int, int> localData = await getLocalFavourites();
     remoteData.forEach((key, value) {
       if (!localData.containsKey(key)) {
         noteRepository.addToFavourites(value);
       } else {

         localData.remove(key);
       }
     });

     localData.forEach((key, value) {
       noteRepository.deleteFromFavourites(value);
     });
   }

  updateLocalNotes() async {
    Map<int, Note> remoteData =
        await getRemoteData<Note>(AppConstants.notesPath);
    print("remote data is =>" + remoteData.toString());
    Map<int, Note> localData = await getLocalNotes();
    remoteData.forEach((key, value) {
      if (!localData.containsKey(key)) {
        noteRepository.addNote(value);
      } else {
        bool isSame = compareTwoNotes(localData[key]!, value);
        if (!isSame) {
          noteRepository.editNote(value);
        }
        localData.remove(key);
      }
    });

    localData.forEach((key, value) {
      noteRepository.deleteNote(value);
    });
  }

  compareTwoNotes(Note first, Note second) {
    bool isSame = true;
    if (first.title != second.title) {
      isSame = false;
    }
    if (first.body != second.body) {
      isSame = false;
    }
    return isSame;
  }

  Future<Map<int, Note>> getLocalNotes() async {
    List<Note> localNotesList = await noteRepository.getAllNotes();
    Map<int, Note> localNotes = {};
    for (Note i in localNotesList) {
      localNotes.putIfAbsent(i.id, () => i);
    }
    return localNotes;
  }
  getLocalFavourites()
  async {
     List<Map<String, dynamic>> temp =
    await localDataSource.getTable(AppConstants.favoriteList);
     Map<int, int> localFavourites = {};
    for (int i = 0; i < temp.length; i++) {

     localFavourites.addAll({temp[i]['id']:temp[i]['id']});
    }


    return localFavourites;
  }
  getRemoteData<T>(String path) async {
    List<Map<String, dynamic>> temp = [];
    temp = await remoteDataSource.getData(path).then((value) {
      print("value is =>" + value.toString());
      return value;
    });
    print("data recieve is =>" + temp.toString());
    Map<int, T> data = {};
    for (int i = 0; i < temp.length; i++) {
      if (T == Note) {
        data.addAll({
          int.parse(temp[i]['id'].toString()): NoteModel.fromJson(temp[i]) as T
        });
      } else {
        data.addAll({temp[i]['id'] as int: temp[i]['id']as int} as Map<int, T>);
      }
    }
    return data;
  }
}
