import 'package:flutter/material.dart';
import 'package:flutter_app/views/tela_inicial_view.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroView(),
        '/home': (context) => const TelaInicialView(),
      },
    );
  }
}