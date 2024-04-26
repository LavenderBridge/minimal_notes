import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:minimal_notes/pages/FullScreenNote.dart';
import 'package:minimal_notes/widgets/NoteTile.dart';
import 'package:minimal_notes/widgets/TodoTile.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

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
              style: GoogleFonts.dmSerifText(fontSize: 30),
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
              context
                  .read<NoteDatabase>()
                  .addNote(_controller.text, _contentController.text);
              _controller.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Save note",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
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

    void initState() {
    //fetch notes on startup
    readNote();
    super.initState();
  }


  @override
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
                  "To-Do",
                  style: GoogleFonts.dmSerifText(
                      fontSize: 48,
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              Expanded(
                child: currentNotes.length == 0
                    ? Center(
                        child: Text("Well ain't you a free man?"),
                      )
                    : ListView.builder(
                        itemCount: currentNotes.length,
                        itemBuilder: (context, index) {
                          Note currentNote = currentNotes[index];
                          return Dismissible(
                            background: Container(color: Colors.red[300]),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete Note"),
                                    content: Text(
                                        "Are you sure you want to delete this note? This action cannot be undon."),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                          )),
                                      TextButton(
                                        onPressed: () {
                                          deleteNote(currentNote.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Yes",
                                          style:
                                              TextStyle(color: Colors.red[300]),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {},
                            child: TodoTile(
                              currentNote: currentNote,
                              // onPressedEdit: () => editNote(currentNote),
                              onPressedEdit: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreenNote(
                                          openedNote: currentNote,
                                          saveFunction: editNote))),
                              onPressedDelete: () => deleteNote(currentNote.id),
                            ),
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