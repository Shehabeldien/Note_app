import 'package:hive_flutter/adapters.dart';

class HiveHelper {
  static const noteBox = "Note_Box";
  static const noteKey = "Note_Key";
  static List<String> myNotes = [];

  static Future<void> getNotes() async {
    // var box = await Hive.openBox(noteBox);
    myNotes = Hive.box(noteBox).get("Note_Key") ?? [];
  }

  //add notes
  static void addNote(String note) async {
    HiveHelper.myNotes.add(note);
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  //delete notes
  static void deleteNote(int index) async {
    HiveHelper.myNotes.removeAt(index);
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  //delete all notes
  static void deleteAllNotes() async {
    HiveHelper.myNotes.clear();
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  //update notes
  static void updateNote(int index, String newNote) async {
    HiveHelper.myNotes[index] = newNote;
    await Hive.box(noteBox).put(noteKey, myNotes);
  }
}
