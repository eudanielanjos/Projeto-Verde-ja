import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

// Imports das Views
import 'package:flutter_app/views/home_view.dart';
import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/tela_inicial_view.dart';
import 'views/denuncia_view.dart';
import 'views/educacao_view.dart';
import 'views/admin_view.dart';
import 'views/admin_educacao_view.dart';
import 'views/historico_admin_view.dart';
import 'views/gestao_coleta_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Erro ao inicializar Firebase: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void alterarDaltonismo(BuildContext context, bool ativo) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setDaltonismo(ativo);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool daltonismo = false;

  void setDaltonismo(bool valor) {
    setState(() {
      daltonismo = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: daltonismo
          ? const ColorFilter.matrix([
              0.567, 0.433, 0, 0, 0,
              0.558, 0.442, 0, 0, 0,
              0, 0.242, 0.758, 0, 0,
              0, 0, 0, 1, 0,
            ])
          : const ColorFilter.mode(
              Colors.transparent,
              BlendMode.multiply,
            ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Seu App de Coleta',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashView(),
          '/home': (context) => const HomeView(),
          '/login': (context) => const LoginView(),
          '/cadastro': (context) => const CadastroView(),
          '/inicial': (context) => const TelaInicialView(),
          '/denuncia': (context) => const LocalDenunciaPage(),
          '/educacao': (context) => const EducacaoView(),
          '/admin': (context) => const AdminMenuView(),
          '/educacaoAdmin': (context) => const EducacaoAdminView(),
          '/historicoAdmin': (context) => const HistoricoAdminView(),
          '/gestaoColetasAdmin': (context) => const ColetaAdmin(),
          '/home_visitante': (context) => const HomeView(), // Adicionada caso use no Fale Conosco
        },
      ),
    );
  }
}