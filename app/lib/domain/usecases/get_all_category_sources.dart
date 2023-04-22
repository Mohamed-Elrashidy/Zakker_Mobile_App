import 'package:app/data/repositories/note_repository.dart';
import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/entities/category.dart';
import 'package:get_it/get_it.dart';

class GetAllCategorySourcesUseCase{
  String category;
  BaseNoteRepository baseNoteRepository;
  GetAllCategorySourcesUseCase({required this.baseNoteRepository,required this.category});
  List<Category>execute()
  {
    return baseNoteRepository.showAllSources(category);
  }
}