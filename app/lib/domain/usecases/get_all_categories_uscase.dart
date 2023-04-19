import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/category.dart';
import '../entities/note.dart';

class GetAllCategoriesUseCase{
  final BaseNoteRepository baseNoteRepository;
  GetAllCategoriesUseCase({required this.baseNoteRepository});
  List<Category> execute()
  {
    return baseNoteRepository.showAllCategories();
  }
}