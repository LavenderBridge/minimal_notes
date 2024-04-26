import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/models/NoteModel.dart';
import 'package:provider/provider.dart';

class FullScreenNote extends StatefulWidget {
  Note openedNote;
  // final void Function()? onPressedSave;
  final void Function(Note) saveFunction;
  FullScreenNote(
      {super.key, required this.openedNote, required this.saveFunction});

  @override
  State<FullScreenNote> createState() => _FullScreenNoteState();
}

class _FullScreenNoteState extends State<FullScreenNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  void initState() {
    _titleController.text = widget.openedNote.text;
    _contentController.text = widget.openedNote.content;
    super.initState();
  }

  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            widget.openedNote.text = _titleController.text;
            widget.openedNote.content = _contentController.text;
            widget.saveFunction(widget.openedNote);
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(border: InputBorder.none),
                style: GoogleFonts.dmSerifText(
                    fontSize: 48,
                    fontWeight: FontWeight.w100,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(border: InputBorder.none),
                minLines: 5,
                maxLines: 10000,
                style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.w100,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
