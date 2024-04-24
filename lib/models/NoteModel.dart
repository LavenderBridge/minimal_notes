import "package:isar/isar.dart";

//for isar. Needed to generate the file
//Run command dart run build_runner build
part 'NoteModel.g.dart';

@Collection()

class Note {
  Id id = Isar.autoIncrement;
  late String text;
  late String content;
}