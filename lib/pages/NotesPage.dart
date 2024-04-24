import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:minimal_notes/pages/FullScreenNote.dart';
import 'package:minimal_notes/widgets/NoteTile.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _contentController = TextEditingController();

// Create note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: TextStyle(fontSize: 30),
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
                hintStyle: TextStyle(fontSize: 30),
              ),
            ),
            TextFormField(
              minLines: 5,
              maxLines: 1000,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Add Content here",
              ),
              controller: _contentController,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NoteDatabase>().addNote(_controller.text, _contentController.text);
              _controller.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: Text("Save note", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
          )
        ],
      ),
    );
  }

  //read note
  void readNote() {
    context.read<NoteDatabase>().getNotes();
  }

  //edit note
  void editNote(Note note) {
    print("TRYING TO EDIT");
    print(note.text);
    context.read<NoteDatabase>().updateNote(note.id, note.text, note.content);
  }

  //delete note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  void initState() {
    //fetch notes on startup
    readNote();
    super.initState();
  }

  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<NoteDatabase>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "Notes",
                  style: GoogleFonts.dmSerifText(
                      fontSize: 48,
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              Expanded(
                child: currentNotes.length == 0 ? Center(child: Text("Well ain't you a free man?"),): ListView.builder(
                  itemCount: currentNotes.length,
                  itemBuilder: (context, index) {
                    Note currentNote = currentNotes[index];
                    return NoteTile(
                      currentNote: currentNote,
                      // onPressedEdit: () => editNote(currentNote),
                      onPressedEdit: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenNote(openedNote: currentNote, saveFunction: editNote))),
                      onPressedDelete: () => deleteNote(currentNote.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
