import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/usecases/get_all_categories_uscase.dart';
import 'package:app/domain/usecases/get_all_category_sources.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/note_repository.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/source.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  BaseNoteRepository baseNoteRepository=GetIt.instance.get<NoteRepository>();

  Future<List<Category>> getAllCategories()async
  {
   List<Category> allCategories=await GetAllCategoriesUseCase( baseNoteRepository:baseNoteRepository).execute();
   emit(GetAllCategories(allCategories: allCategories));
   return allCategories;
  }

  Future<List<Source>> getCategorySources(int category)
  async {
    List<Source> allSources= await GetAllCategorySourcesUseCase( baseNoteRepository:baseNoteRepository,category: category).execute();
  print(" we are at emit "+ allSources.toString());
    emit(GetCategorySources(allCategorySources: allSources));

    return allSources;
  }




}

