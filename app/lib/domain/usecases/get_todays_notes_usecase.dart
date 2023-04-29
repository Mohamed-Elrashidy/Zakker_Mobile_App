import '../base_repositories/base_note_repository.dart';
import '../entities/note.dart';

class GetTodaysNotesUseCase{
  final BaseNoteRepository baseNoteRepository;
  GetTodaysNotesUseCase({required this.baseNoteRepository});
  Future<List<Note>> execute() {
    return baseNoteRepository.showTodaysNotes();
  }
}