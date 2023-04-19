import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class DeleteNoteUsCase {
  final BaseNoteRepository baseNoteRepository;
  DeleteNoteUsCase({required this.baseNoteRepository});
  void execute(int noteId)
  {
    baseNoteRepository.deleteNote(noteId);
  }
}