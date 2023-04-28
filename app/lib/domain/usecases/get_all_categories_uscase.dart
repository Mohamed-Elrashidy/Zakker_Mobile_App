import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/category.dart';

class GetAllCategoriesUseCase{
  final BaseNoteRepository baseNoteRepository;
  GetAllCategoriesUseCase({required this.baseNoteRepository});
  Future<List<Category>> execute()
  {
    return baseNoteRepository.showAllCategories();
  }
}