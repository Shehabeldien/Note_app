import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../hive.helper.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  void getNotes() async {
    emit(Noteloadingstate());
    await Future.delayed(const Duration(seconds: 2));
    if (HiveHelper.myNotes.isNotEmpty) {
      emit(NoteSuccessState());
    } else {
      emit(NoteEmptyState());
    }
  }

  void addNote(String note) async {
    HiveHelper.addNote(note);
    emit(NoteAddedState());
  }

  void deleteNote(int index) async {
    HiveHelper.deleteNote(index);
    emit(NoteDeleteState());
  }

  void deleteAllNotes() async {
    HiveHelper.deleteAllNotes();
    emit(NoteClearAllState());
  }

  void updateNote(int index, String newNote) async {
    HiveHelper.updateNote(index, newNote);
    emit(NoteUpdateState());
  }
}
