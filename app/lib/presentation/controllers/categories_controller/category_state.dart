part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}
class GetAllCategories extends CategoryState{
  List<Category> allCategories;
  GetAllCategories({required this.allCategories});

}
class GetCategorySources extends CategoryState{
  List<Source> allCategorySources;
  GetCategorySources({required this.allCategorySources});
}