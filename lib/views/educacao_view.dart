import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'tela_inicial_view.dart';
import 'perfil_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';

class EducacaoView extends StatefulWidget {
  const EducacaoView({super.key});

  @override
  State<EducacaoView> createState() => _EducacaoViewState();
}

class _EducacaoViewState extends State<EducacaoView> {
 // Índice da aba "Educação" no menu

  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  late YoutubePlayerController _controller3;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  Widget buildVideoCard({
    required YoutubePlayerController controller,
    required String titulo,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 76, 107, 99),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(18)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 MENU COMPLETO À DIREITA
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 25),
              decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Olá, Usuario",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaInicialView()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.calendar_today,
                    title: "Coleta Regular",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.school,
                    title: "Educação",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PerfilPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.history,
                    title: "Histórico de Denúncias",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HistoricoDenunciasView(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.settings,
                    title: "Configurações",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracaoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TelaInicialView()),
                  );
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(64, 118, 78, 1), Colors.white],
                stops: [0.0, 0.5],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        'assets/images/logo3.png',
                        width: 170,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Educação Ambiental",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 76, 107, 99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Fique Informado:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 76, 107, 99),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Assista vídeos curtos para aprender sobre sustentabilidade, reciclagem e cuidado com o meio ambiente.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    buildVideoCard(
                      controller: _controller1,
                      titulo: "Educação Ambiental",
                    ),
                    const Divider(),
                    buildVideoCard(
                      controller: _controller2,
                      titulo: "Sustentabilidade na Prática",
                    ),
                    const Divider(),
                    buildVideoCard(
                      controller: _controller3,
                      titulo: "Reciclagem e Meio Ambiente",
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔥 BOTÃO DO MENU À DIREITA
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Builder(
                builder: (context) => IconButton(
                  padding: const EdgeInsets.only(right: 8, top: 8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}