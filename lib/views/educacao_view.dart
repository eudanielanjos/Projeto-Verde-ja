import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'tela_inicial_view.dart';
import 'perfil_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'coleta_view.dart';

class EducacaoView extends StatefulWidget {
  const EducacaoView({super.key});

  @override
  State<EducacaoView> createState() => _EducacaoViewState();
}

class _EducacaoViewState extends State<EducacaoView> {
  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  late YoutubePlayerController _controller3;

  // --- ESTADOS DE ACESSIBILIDADE ---
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
    _controller1 = YoutubePlayerController(
      initialVideoId: "oV3pK3SOjxo",
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    _controller2 = YoutubePlayerController(
      initialVideoId: "GXFXdtycljo",
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    _controller3 = YoutubePlayerController(
      initialVideoId: "AiP2qscQUes",
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  // Carrega as configurações salvas
  Future<void> carregarAcessibilidade() async {
    final prefs = await SharedPreferences.getInstance();
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
    carregarAcessibilidade();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- DEFINIÇÃO DE CORES DINÂMICAS ---
    Color corTema;
    if (altoContraste) {
      corTema = Colors.black;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64);
    } else {
      corTema = const Color(0xFF1F5C3A);
    }

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
                      "Olá, Usuario",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildMenuCard(
                      icon: Icons.home,
                      title: "Início",
                      corIcone: corTema,
                      onTap: () {
                        vibrar();
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
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
                      onTap: () => Navigator.pop(context),
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
                  onTap: () async {
                    vibrar();
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
                    }
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                Colors.white,
              ],
              stops: const [0.0, 0.35],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Builder(
                  builder: (context) => Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.menu, color: altoContraste ? Colors.black : Colors.black87, size: 30),
                      onPressed: () {
                        vibrar();
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ),

                Center(
                  child: Image.asset('assets/images/logo3.png', width: zoomInterface ? 220 : 180),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    "Educação Ambiental ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Explore os conteúdos abaixo para aprender sobre o descarte correto e sustentabilidade.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                buildVideoCard(controller: _controller1, titulo: "Como Reciclar", corIcone: corTema),
                buildVideoCard(controller: _controller2, titulo: "Sustentabilidade", corIcone: corTema),
                buildVideoCard(controller: _controller3, titulo: "Meio Ambiente", corIcone: corTema),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVideoCard({required YoutubePlayerController controller, required String titulo, required Color corIcone}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.play_circle_fill, color: corIcone),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corIcone),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corIcone, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
}