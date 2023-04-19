import 'package:app/data/local_data_source/local_data_source.dart';
import 'package:app/data/repositories/note_repository.dart';
import 'package:app/utils/dimension_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dependancy {
  final BuildContext context;
  Dependancy(this.context);

  Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    GetIt locator = GetIt.instance;
    locator.registerSingleton(Dimension(context: context));
    locator.registerSingleton(
        LocalDataSource(sharedPreferences: sharedPreferences));
    locator.registerSingleton(
        NoteRepository(localDataSource: GetIt.instance.get<LocalDataSource>()));
  }
}
