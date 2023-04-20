import 'package:app/domain/base_repositories/base_note_repository.dart';

import '../entities/note.dart';

class GetAllNotesUseCase{
  final BaseNoteRepository baseNoteRepository;
  GetAllNotesUseCase({required this.baseNoteRepository});
  List<Note> execute()
  {
    return baseNoteRepository.getAllNotes();
  }
}