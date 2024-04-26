import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:provider/provider.dart';

class TodoTile extends StatefulWidget {
  final Note currentNote;
  final void Function() onPressedEdit;
  final void Function() onPressedDelete;
  TodoTile(
      {super.key,
      required this.currentNote,
      required this.onPressedEdit,
      required this.onPressedDelete});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  TextEditingController _titleController = TextEditingController();

  TextEditingController _contentController = TextEditingController();

  void expandTile(BuildContext context, int id) async {
    var fetchedNote = await NoteDatabase().getSpecificNote(id);
    if (fetchedNote != null) {
      _titleController.text = fetchedNote.text;
      _contentController.text = fetchedNote.text;
      showModalBottomSheet(
          elevation: 10,
          enableDrag: true,
          showDragHandle: true,
          isDismissible: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          context: (context),
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Text(
                            fetchedNote.text,
                            style: GoogleFonts.dmSerifText(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onPressedEdit();
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                    Text(
                      fetchedNote.content,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  bool checkedStatus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        onTap: () => expandTile(context, widget.currentNote.id),
        // tileColor: Theme.of(context).colorScheme.primary,
        // horizontalTitleGap: 22,
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          widget.currentNote.text,
          style: GoogleFonts.dmSerifText(
            fontSize: 22,
            decoration: checkedStatus == true ? TextDecoration.lineThrough : null
          ),
        ),
        leading: IconButton(
            onPressed: () {
              setState(() {
                checkedStatus = !checkedStatus;
              });
            },
            icon: checkedStatus == true
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => widget.onPressedEdit(),
              icon: Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Delete Note"),
                        content: Text(
                            "Are you sure you want to delete this note? This action cannot be undon."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                              )),
                          TextButton(
                              onPressed: () {
                                widget.onPressedDelete();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(color: Colors.red[300]),
                              )),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

// editNote(currentNote)
// deleteNote(currentNote.id),