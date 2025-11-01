// main.dart - Perbaikan struktur navigasi
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_service.dart';
import 'screens/main_screen.dart';
import 'screens/note_form.dart';
import 'screens/note_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gunakan service untuk inisialisasi Hive
  await HiveService.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MainScreen(),
        '/add': (_) => const NoteForm(),
        '/edit': (_) => const NoteForm(isEditing: true),
        '/detail': (_) => const NoteDetailScreen(),
      },
    );
  }
}
