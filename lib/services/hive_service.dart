import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class HiveService {
  static const String boxName = 'notes';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(boxName);
  }

  static Box<Note> getNotesBox() => Hive.box<Note>(boxName);
}
