import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';
import 'providers/song_provider.dart';
import 'providers/performance_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(PalcoApp(db: db));
}

class PalcoApp extends StatelessWidget {
  final AppDatabase db;
  const PalcoApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongProvider(db)),
        ChangeNotifierProvider(create: (_) => PerformanceProvider()),
      ],
      child: MaterialApp(
        title: 'Palco',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
