import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/usecases/get_all_categories_uscase.dart';
import 'package:app/domain/usecases/get_all_category_sources.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/note_repository.dart';
import '../../../domain/entities/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  BaseNoteRepository baseNoteRepository=GetIt.instance.get<NoteRepository>();

  List<Category> getAllCategories()
  {
   List<Category> allCategories= GetAllCategoriesUseCase( baseNoteRepository:baseNoteRepository).execute();
   emit(GetAllCategories(allCategories: allCategories));
   return allCategories;
  }

  List<Category> getCategorySources(String category)
  {
    List<Category> allCategories= GetAllCategorySourcesUseCase( baseNoteRepository:baseNoteRepository,category: category).execute();
    emit(GetAllCategories(allCategories: allCategories));

    return allCategories;
  }




}
