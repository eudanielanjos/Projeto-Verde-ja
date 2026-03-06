import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'tela_inicial_view.dart';
import 'perfil_view.dart';

class EducacaoView extends StatefulWidget {
  const EducacaoView({super.key});

  @override
  State<EducacaoView> createState() => _EducacaoViewState();
}

class _EducacaoViewState extends State<EducacaoView> {
  int _selectedIndex = 2;

  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  late YoutubePlayerController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = YoutubePlayerController(
      initialVideoId: "oV3pK3SOjxo",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller2 = YoutubePlayerController(
      initialVideoId: "GXFXdtycljo",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller3 = YoutubePlayerController(
      initialVideoId: "AiP2qscQUes",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaInicialView(),
        ),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PerfilPage(),
        ),
      );
    }
  }

  Widget buildVideoCard({
    required YoutubePlayerController controller,
    required String titulo,
  }) {
    return Container(
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
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 76, 107, 99),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(64, 118, 78, 1),
              Colors.white,
            ],
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

                const SizedBox(height: 20),

                const Text(
                  'Fique Informado:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 76, 107, 99),
                  ),
                ),

                const SizedBox(height: 20),

                buildVideoCard(
                  controller: _controller1,
                  titulo: "Educação Ambiental",
                ),

                buildVideoCard(
                  controller: _controller2,
                  titulo: "Sustentabilidade na Prática",
                ),

                buildVideoCard(
                  controller: _controller3,
                  titulo: "Reciclagem e Meio Ambiente",
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 76,
        backgroundColor: const Color(0xFF1F5C3A),
        indicatorColor: Colors.white24,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.place_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.place, color: Colors.white),
            label: 'Coleta',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.school, color: Colors.white),
            label: 'Educação',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}