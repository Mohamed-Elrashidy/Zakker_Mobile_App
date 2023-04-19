import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class EditNoteUseCase {
  final BaseNoteRepository baseNoteRepository;
  EditNoteUseCase({required this.baseNoteRepository});
  void execute(Note note)
  {
    baseNoteRepository.editNote(note);
  }
}