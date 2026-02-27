import 'package:flutter/material.dart';
import 'package:flutter_app/views/login_views.dart';
import 'views/home_view.dart';
import 'views/splash_view.dart';

void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(), // 👈 usando a tela importada
    );
  }
}