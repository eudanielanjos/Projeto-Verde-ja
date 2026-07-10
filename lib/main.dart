import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // IMPORTADO PARA OTOMIZAÇÃO

// Imports para a inicialização de formatação de data e internacionalização
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';

// IMPORT CORRETO: Apontando para o arquivo gerado localmente na sua pasta l10n
import 'l10n/app_localizations.dart'; 

// Imports das Views
import 'package:flutter_app/views/home_view.dart';
import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/tela_inicial_view.dart' hide AppLocalizations;
import 'views/denuncia_view.dart';
import 'views/educacao_view.dart';
import 'views/admin_view.dart';
import 'views/admin_educacao_view.dart';
import 'views/historico_admin_view.dart';
import 'views/gestao_coleta_view.dart';

void main() async {
  // 1. Garante a inicialização dos bindings nativos do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializa o Firebase ANTES do runApp de forma segura.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase inicializado com sucesso!");

    // 🚀 CONFIGURAÇÃO DE ALTA PERFORMANCE PARA O FIRESTORE
    // Faz a leitura/escrita serem locais e em segundo plano, acelerando o app drasticamente
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, // Cache offline para acesso ultra rápido
    );
    debugPrint("Configurações de cache do Firestore aplicadas!");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "admin@verdeja.com", 
        password: "admin123", 
      );
      debugPrint("Login automático do Admin efetuado com sucesso!");
    } catch (authError) {
      debugPrint("Aviso de Login Automático: $authError");
    }
  } catch (e) {
    debugPrint("Erro crítico ao inicializar Firebase: $e");
  }

  // 3. Carrega o idioma persistido via SharedPreferences antes de iniciar a UI
  Locale localeInicial = const Locale('pt');
  try {
    final prefs = await SharedPreferences.getInstance();
    final String idiomaSalvo = prefs.getString('idiomaSelecionado') ?? "Português";
    
    switch (idiomaSalvo) {
      case "English":
        localeInicial = const Locale('en');
        break;
      case "Español":
        localeInicial = const Locale('es');
        break;
      case "Français":
        localeInicial = const Locale('fr');
        break;
      default:
        localeInicial = const Locale('pt');
    }
  } catch (e) {
    debugPrint("Erro ao carregar SharedPreferences no main: $e");
  }

  // 4. Inicializa as datas baseando-se no idioma detectado de forma segura
  try {
    await initializeDateFormatting('${localeInicial.languageCode}_BR', null);
  } catch (e) {
    debugPrint("Erro ao inicializar formatação de datas: $e");
  }
  
  // 5. Executa o app passando o idioma inicial detectado
  runApp(MyApp(localeInicial: localeInicial));
}

class MyApp extends StatefulWidget {
  final Locale localeInicial; 
  
  const MyApp({super.key, required this.localeInicial});

  static void alterarDaltonismo(BuildContext context, bool ativo) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setDaltonismo(ativo);
  }

  // 🔹 ESSA FUNÇÃO ATUALIZA O APP INTEIRO EM TEMPO REAL
  static void setLocale(BuildContext context, Locale novoLocale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(novoLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool daltonismo = false;
  Locale? _locale; 

  @override
  void initState() {
    super.initState();
    _locale = widget.localeInicial; 
  }

  void setDaltonismo(bool valor) {
    setState(() {
      daltonismo = valor;
    });
  }

  // Método que atualiza o estado local do main e força a reconstrução do MaterialApp
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
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
        
        // 🔹 Vincula diretamente o Locale dinâmico da State
        locale: _locale, 
        localizationsDelegates: const [
          AppLocalizations.delegate, 
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt'), 
          Locale('en'), 
          Locale('es'), 
          Locale('fr'), 
        ],

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
          '/home_visitante': (context) => const HomeView(),
        },
      ),
    );
  }
}