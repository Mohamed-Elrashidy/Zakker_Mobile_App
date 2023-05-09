import 'package:app/data/local_data_source/local_data_source_sqlflite.dart';
import 'package:app/data/repositories/note_repository.dart';
import 'package:app/services/notification_services.dart';
import 'package:app/utils/dimension_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/note_model.dart';

class Dependancy {
  void initDimensionScale(BuildContext context) {
    try {
      GetIt.instance.get<Dimension>();
    } catch (e) {
      GetIt.instance.registerSingleton(Dimension(context: context));
    }
  }

  Future<void> initControllers() async {
    GetIt locator = GetIt.instance;

    try{
      GetIt.instance.get<LocalDataSource>();

    }
    catch(e){
      locator.registerSingleton(LocalDataSource());

    }
    await locator.get<LocalDataSource>().initDb();

    try {
      GetIt.instance.get<NoteRepository>();
    } catch (e) {
      locator.registerSingleton(NoteRepository(localDataSource:GetIt.instance.get<LocalDataSource>()));
    }

    try {
      await NotificationServices.initialize(
          GetIt.instance.get<FlutterLocalNotificationsPlugin>());
    } catch (e) {
      GetIt.instance.registerSingleton(FlutterLocalNotificationsPlugin());
      await NotificationServices.initialize(
          GetIt.instance.get<FlutterLocalNotificationsPlugin>());
    }
  }
}
