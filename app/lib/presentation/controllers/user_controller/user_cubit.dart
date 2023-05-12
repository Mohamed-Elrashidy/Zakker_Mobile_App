import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

   void getUserInfo()
   {
     User user =User(email:"mohamed.elrashidy354@gmail.com",password: "12345",name:"Mohamed Elrashidy");
     emit(UserInfoLoaded(user: user));
   }
}
