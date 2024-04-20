import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_api_app/screens/todo_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var kLightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 202, 252, 0),
    );
    var kDarkColorScheme = ColorScheme.fromSeed(  
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(252, 204, 255, 0),
    );
    return MaterialApp(
      title: 'Todo App', 
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
      ),
      theme: ThemeData().copyWith( 
        colorScheme: kLightColorScheme,
      ),
      home: const TodoListPage(),
    );
  }
}
