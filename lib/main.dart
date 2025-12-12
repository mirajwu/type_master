import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/game_controller.dart';
import 'view/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()..loadUser()),
      ],
      child: const TypeMasterApp(),
    ),
  );
}

class TypeMasterApp extends StatelessWidget {
  const TypeMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Type Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}