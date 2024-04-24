import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  //provider changenotifier
  static late Isar isar;

  //Initialize
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: directory.path);
  }

  //List of notes
  List<Note> currentNotes = [];
  late Note singleFetchedNote;

  //Create
  Future<void> addNote(String title, String content) async {
    final newNote = Note()..text = title..content = content;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //read from db to update
    await getNotes();
  }

  //Read
  Future<void> getNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    // currentNotes.clear();
    // currentNotes.addAll(fetchedNotes);
    currentNotes = fetchedNotes;
    notifyListeners(); //Provider function to notify of changes
  }

  //Read specific Note
  Future<Note?> getSpecificNote(int id) async {
    var note = await isar.notes.get(id);
    if (note != null) {
      return note;
    }
  }

  //Update
  Future<void> updateNote(int id, String newText, String content) async {
    final existingNode = await isar.notes.get(id);
    if (existingNode != null) {
      existingNode.text = newText;
      existingNode.content = content;
      //save to db
      await isar.writeTxn(() => isar.notes.put(existingNode));
      //read from db to update
      await getNotes();
    }
  }

  //Delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await getNotes();
  }
}
