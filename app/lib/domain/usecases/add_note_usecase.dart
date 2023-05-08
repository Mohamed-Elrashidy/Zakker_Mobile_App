import 'package:app/domain/base_repositories/base_note_repository.dart';
import '../entities/note.dart';

class AddNoteUseCase {
  final BaseNoteRepository baseNoteRepository;
  AddNoteUseCase({required this.baseNoteRepository});
  Future<void> execute(Note note) async {
   await baseNoteRepository.addNote(note);
  }
}
