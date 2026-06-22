import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

// Importações das suas views
import 'denuncia_view.dart';
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'coleta_view.dart';
import 'map_view.dart';
import 'admin_view.dart'; 

class TelaInicialView extends StatefulWidget {
  const TelaInicialView({super.key});

  @override
  State<TelaInicialView> createState() => _TelaInicialViewState();
}

class _TelaInicialViewState extends State<TelaInicialView> {
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  bool zoomInterface = false;
  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    carregarAcessibilidade();
  }

  Future<void> carregarAcessibilidade() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      zoomInterface = prefs.getBool('zoomInterface') ?? false;
      escalaFonte = fonteGrande ? 1.25 : 1.0;
    });
  }

  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  void navegarParaTela(Widget tela) async {
    vibrar();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
    if (mounted) {
      setState(() {
        carregarAcessibilidade(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color corTema;
    Color corCards;
    Color corTextoCard = Colors.white;

    if (altoContraste) {
      corTema = Colors.black;
      corCards = Colors.black;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64);
      corCards = const Color(0xFF37474F);
    } else {
      corTema = const Color(0xFF1F5C3A);
      corCards = const Color.fromRGBO(137, 186, 21, 1);
    }

    double alturaCard = zoomInterface ? 125 : 105;
    double tamanhoTituloCard = zoomInterface ? 21 : 19;
    double tamanhoSubCard = zoomInterface ? 15 : 13;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        endDrawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 25),
                decoration: BoxDecoration(color: corTema),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Olá, Usuário",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildMenuCard(
                      icon: Icons.home,
                      title: "Início",
                      corIcone: corTema,
                      onTap: () {
                        vibrar();
                        Navigator.pop(context);
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.calendar_month,
                      title: "Coleta Regular",
                      corIcone: corTema,
                      onTap: () {
                        Navigator.pop(context);
                        navegarParaTela(const ColetaView());
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.school,
                      title: "Educação",
                      corIcone: corTema,
                      onTap: () {
                        Navigator.pop(context);
                        navegarParaTela(const EducacaoView());
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.history_edu,
                      title: "Histórico de Denúncias",
                      corIcone: corTema,
                      onTap: () {
                        Navigator.pop(context);
                        navegarParaTela(const HistoricoDenunciasView());
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.person,
                      title: "Perfil",
                      corIcone: corTema,
                      onTap: () {
                        Navigator.pop(context);
                        navegarParaTela(const PerfilPage());
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.settings,
                      title: "Configurações",
                      corIcone: corTema,
                      onTap: () {
                        Navigator.pop(context);
                        navegarParaTela(const ConfiguracaoPage());
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    vibrar();
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeView()),
                        (route) => false,
                      );
                    }
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Sair da conta",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                altoContraste ? Colors.black : corTema.withOpacity(0.7),
                Colors.white
              ],
              stops: const [0.0, 0.35],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.menu, size: 30, color: altoContraste ? Colors.black : Colors.black87),
                      onPressed: () {
                        vibrar();
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                  Center(child: Image.asset('assets/images/logo3.png', width: zoomInterface ? 210 : 180)),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Bem-vindo ao Verdeja",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Escolha uma das opções abaixo para interagir e ajudar a preservar o meio ambiente.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data?.email == 'verdejaprojeto@gmail.com') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _buildMainCard(
                            imagePath: 'assets/images/logo.png',
                            title: "Painel de Admin", 
                            subtitle: "Gerencie denúncias enviadas pelos usuários",
                            icon: Icons.admin_panel_settings,
                            corFundo: const Color(0xFF133621),
                            corTexto: Colors.white,
                            altura: alturaCard,
                            tamTitulo: tamanhoTituloCard,
                            tamSub: tamanhoSubCard,
                            onTap: () => navegarParaTela(const AdminMenuView()),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _buildMainCard(
                    imagePath: 'assets/images/lixo.png',
                    title: "Fazer Denúncia",
                    subtitle: "Denuncie descartes incorretos ou problemas de lixo",
                    icon: Icons.arrow_forward_ios,
                    corFundo: corCards,
                    corTexto: corTextoCard,
                    altura: alturaCard,
                    tamTitulo: tamanhoTituloCard,
                    tamSub: tamanhoSubCard,
                    onTap: () => navegarParaTela(const LocalDenunciaPage()),
                  ),
                  const SizedBox(height: 15),
                  _buildMainCard(
                    imagePath: 'assets/images/ponto.png',
                    title: "Pontos de Coleta",
                    subtitle: "Encontre os locais de descarte e ecopontos próximos",
                    icon: Icons.arrow_forward_ios,
                    corFundo: corCards,
                    corTexto: corTextoCard,
                    altura: alturaCard,
                    tamTitulo: tamanhoTituloCard,
                    tamSub: tamanhoSubCard,
                    onTap: () => navegarParaTela(const MapaView()),
                  ),
                  const SizedBox(height: 15),
                  _buildMainCard(
                    imagePath: 'assets/images/icon2.png',
                    title: "Coleta Seletiva",
                    subtitle: "Consulte os dias e horários das coletas em seu bairro",
                    icon: Icons.calendar_month,
                    corFundo: corCards,
                    corTexto: corTextoCard,
                    altura: alturaCard,
                    tamTitulo: tamanhoTituloCard,
                    tamSub: tamanhoSubCard,
                    onTap: () => navegarParaTela(const ColetaView()),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corIcone, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: corIcone),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                Icon(Icons.arrow_forward_ios, color: corIcone, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard({
    required String imagePath, 
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color corFundo,
    required Color corTexto,
    required double altura,
    required double tamTitulo,
    required double tamSub,
    required VoidCallback onTap
  }) {
    return SizedBox(
      height: altura,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Card(
          color: corFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: altoContraste ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(imagePath, width: zoomInterface ? 50 : 45),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: TextStyle(fontSize: tamTitulo, fontWeight: FontWeight.bold, color: corTexto),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle, 
                        style: TextStyle(color: corTexto.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: tamSub),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: corTexto, size: zoomInterface ? 20 : 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}