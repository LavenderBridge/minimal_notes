import 'package:flutter/material.dart';
import 'package:minimal_notes/models/NoteDatabasee.dart';
import 'package:minimal_notes/pages/NotesPage.dart';
import 'package:minimal_notes/pages/TodoPage.dart';
import 'package:minimal_notes/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize note database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize()
      .then((value) => print("DATABASE INITIALIZED"));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: PageView(children: [
        NotesPage(),
        TodoPage(),
      ]),
    );
  }
}
