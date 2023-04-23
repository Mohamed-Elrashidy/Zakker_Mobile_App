import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class AddToFavouritesUseCase {
  final BaseNoteRepository baseNoteRepository;
  AddToFavouritesUseCase({required this.baseNoteRepository});
  void execute(int noteId)
  {
    baseNoteRepository.addToFavourites(noteId);
  }
}