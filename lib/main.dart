import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/models.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => NavModel(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yandex Homework",
      home: HomeScreen()
    );
  }
}
