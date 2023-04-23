import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class DeleteFromFavouritesUseCase {
  final BaseNoteRepository baseNoteRepository;
  DeleteFromFavouritesUseCase({required this.baseNoteRepository});
  void execute(int noteId)
  {
    baseNoteRepository.deleteFromFavourites(noteId);
  }
}