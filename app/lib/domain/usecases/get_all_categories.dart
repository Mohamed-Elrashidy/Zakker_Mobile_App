import 'package:app/data/repositories/note_repository.dart';
import 'package:app/domain/base_repositories/base_note_repository.dart';
import 'package:app/domain/entities/category.dart';
import 'package:get_it/get_it.dart';

class GetAllCategories{
  BaseNoteRepository baseNoteRepository=GetIt.instance.get<NoteRepository>();
  List<Category>execute()
  {
    return baseNoteRepository.showAllCategories();
  }
}