import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatelessWidget {
  final Note currentNote;
  final void Function() onPressedEdit;
  final void Function() onPressedDelete;
  NoteTile(
      {super.key,
      required this.currentNote,
      required this.onPressedEdit,
      required this.onPressedDelete});

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
                            style: GoogleFonts.dmSerifText(fontSize: 48),
                          ),
                        ),
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                          onPressedEdit();
                          
                        }, icon: Icon(Icons.edit)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: ListTile(
        onTap: () => expandTile(context, currentNote.id),
        // tileColor: Theme.of(context).colorScheme.primary,
        // horizontalTitleGap: 22,
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          currentNote.text,
          style: TextStyle(fontSize: 20),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => onPressedEdit(),
              icon: Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () => onPressedDelete(),
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