import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // MENU À DIREITA (Copiado da sua Tela Inicial)
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
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.calendar_month,
                    title: "Coleta Regular",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.school,
                    title: "Educação",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuCard(
                    icon: Icons.history_edu,
                    title: "Histórico de Denúncias",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.settings,
                    title: "Configurações",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage()));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
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

      // CORPO DA TELA
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(120, 159, 130, 1), Colors.white], // Cores da sua Home
            stops: [0.0, 0.2], // Stop da sua Home
          ),
        ),
        // O SingleChildScrollView permite que você mexe a tela para baixo!
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Efeito elástico ao puxar
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Botão de Menu (Igual à Home)
              Builder(
                builder: (context) => Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),

              Center(
                child: Image.asset('assets/images/logo3.png', width: 180),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  "Educação Ambiental 🌿",
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

              // Seção de Vídeos
              buildVideoCard(controller: _controller1, titulo: "Como Reciclar"),
              buildVideoCard(controller: _controller2, titulo: "Sustentabilidade"),
              buildVideoCard(controller: _controller3, titulo: "Meio Ambiente"),
              
              const SizedBox(height: 40), // Espaço extra no final para não cortar o último vídeo
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoCard({required YoutubePlayerController controller, required String titulo}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                const Icon(Icons.play_circle_fill, color: Color(0xFF1F5C3A)),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A)),
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

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}