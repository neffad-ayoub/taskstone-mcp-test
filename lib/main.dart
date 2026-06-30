import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'services/task_service.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.anonKey,
  );

  final taskService = TaskService(Supabase.instance.client);

  runApp(TaskStoneApp(taskService: taskService));
}

class TaskStoneApp extends StatelessWidget {
  final TaskService taskService;

  const TaskStoneApp({super.key, required this.taskService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskStone',
      debugShowCheckedModeBanner: false,
      theme: _buildCavemanTheme(),
      home: HomePage(taskService: taskService),
    );
  }

  ThemeData _buildCavemanTheme() {
    const earthyBrown = Color(0xFF5D4037);
    const stoneGray = Color(0xFF424242);
    const warmOchre = Color(0xFFFF8F00);
    const boneWhite = Color(0xFFFFF8E1);
    const darkCave = Color(0xFF2E1B0E);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: earthyBrown,
        onPrimary: boneWhite,
        secondary: warmOchre,
        onSecondary: darkCave,
        tertiary: stoneGray,
        onTertiary: boneWhite,
        error: const Color(0xFFB71C1C),
        onError: boneWhite,
        surface: boneWhite,
        onSurface: darkCave,
        primaryContainer: const Color(0xFFD7CCC8),
        onPrimaryContainer: earthyBrown,
        secondaryContainer: const Color(0xFFFFECB3),
        onSecondaryContainer: darkCave,
      ),
      scaffoldBackgroundColor: boneWhite,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
