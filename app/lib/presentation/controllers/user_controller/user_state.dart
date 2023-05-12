part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserInfoLoaded extends UserState {
  User user;
  UserInfoLoaded({required this.user});
}
