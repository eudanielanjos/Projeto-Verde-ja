import 'package:flutter/material.dart';
import 'tela_inicial_view.dart';
import 'meus_dados_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'educacao_view.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EducacaoView()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeView()),
                    (route) => false,
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

      body: _buildDashboard(),

      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: const Color(0xFF1F5C3A),
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.white24,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TelaInicialView()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EducacaoView()),
            );
          }
        },
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

  Widget _buildDashboard() {
    return Container(
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
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF1F5C3A),
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "MEU PERFIL",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F5C3A),
                  ),
                ),
                const SizedBox(height: 30),
                _buildButton(
                  Icons.person,
                  "Meus dados",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeusDadosView(),
                      ),
                    );
                  },
                ),
                _buildButton(Icons.chat_bubble, "Fale conosco"),
                _buildButton(Icons.menu_book, "Regulamento"),
              ],
            ),
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
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF5E7F6B),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
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