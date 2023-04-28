import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class GetFavouriteNotesUseCase {
  final BaseNoteRepository baseNoteRepository;
  GetFavouriteNotesUseCase({required this.baseNoteRepository});
  Future<List<Note>> execute() {
    return baseNoteRepository.showFavouriteNotes();
  }
}
