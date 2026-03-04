import 'package:flutter/material.dart';
import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/tela_inicial_view.dart';
import 'views/denuncia_view.dart'; // 👈 IMPORTE SUA TELA

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
        '/denuncia': (context) => const LocalDenunciaPage(), // 👈 NOVA ROTA
      },
    );
  }
}
