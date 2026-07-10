import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

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
  List<Map<String, String>> _videos = [];
  List<YoutubePlayerController> _controllers = [];
  bool _isLoading = true;

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
    _inicializarTela();
  }

  Future<void> _inicializarTela() async {
    await carregarAcessibilidade();
    await _carregarVideos();
  }

  Future<void> _carregarVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? videosJson = prefs.getString('lista_videos');
    
    List<Map<String, String>> listaCarregada = [];
    
    if (videosJson != null) {
      final List<dynamic> decoded = jsonDecode(videosJson);
      listaCarregada = decoded.map((item) => Map<String, String>.from(item)).toList();
    } else {
      listaCarregada = [
        {"titulo": "Manual da Reciclagem", "link": "oV3pK3SOjxo"},
        {"titulo": "Sustentabilidade Urbana", "link": "GXFXdtycljo"},
        {"titulo": "Preservação de Rios", "link": "AiP2qscQUes"},
      ];
    }

    // Limpar controllers antigos se houver
    for (var c in _controllers) {
      c.dispose();
    }

    // Inicializar dinamicamente os controllers do YouTube
    _controllers = listaCarregada.map((video) {
      return YoutubePlayerController(
        initialVideoId: video['link']!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }).toList();

    setState(() {
      _videos = listaCarregada;
      _isLoading = false;
    });
  }

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
    _inicializarTela(); // Recarrega os vídeos e acessibilidade ao voltar
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        endDrawer: _buildDrawer(corTema),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                altoContraste ? Colors.black : corTema.withOpacity(0.15),
                Colors.white,
              ],
              stops: const [0.0, 0.25],
            ),
          ),
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.menu_rounded, color: altoContraste ? Colors.black : Colors.black87, size: 32),
                        onPressed: () {
                          vibrar();
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ),
                    Center(
                      child: Image.asset('assets/images/logo3.png', width: zoomInterface ? 220 : 160),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Educação Ambiental",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Explore os conteúdos abaixo para aprender sobre o descarte correto e sustentabilidade.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    
                    _videos.isEmpty 
                      ? const Center(child: Text("Nenhum conteúdo disponível no momento."))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _videos.length,
                          itemBuilder: (context, index) {
                            return _buildUserVideoCard(
                              controller: _controllers[index], 
                              titulo: _videos[index]['titulo']!, 
                              corIcone: corTema
                            );
                          },
                        ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildUserVideoCard({required YoutubePlayerController controller, required String titulo, required Color corIcone}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.play_circle_fill_rounded, color: corIcone, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: altoContraste ? Colors.black : corIcone),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: corIcone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(Color corTema) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: BoxDecoration(color: corTema),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Olá, Usuário",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildMenuCard(icon: Icons.home_rounded, title: "Início", corIcone: corTema, onTap: () {
                  vibrar();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                }),
                _buildMenuCard(icon: Icons.calendar_month_rounded, title: "Coleta Regular", corIcone: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const ColetaView());
                }),
                _buildMenuCard(icon: Icons.school_rounded, title: "Educação", corIcone: corTema, onTap: () => Navigator.pop(context)),
                _buildMenuCard(icon: Icons.history_edu_rounded, title: "Histórico de Denúncias", corIcone: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const HistoricoDenunciasView());
                }),
                _buildMenuCard(icon: Icons.person_rounded, title: "Perfil", corIcone: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const PerfilPage());
                }),
                _buildMenuCard(icon: Icons.settings_rounded, title: "Configurações", corIcone: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const ConfiguracaoPage());
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () async {
                vibrar();
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corIcone, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: corIcone),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: corIcone.withOpacity(0.5), size: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: altoContraste ? const BorderSide(color: Colors.black, width: 1.5) : BorderSide.none,
        ),
        tileColor: altoContraste ? Colors.white : Colors.grey[50],
      ),
    );
  }
}