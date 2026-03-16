import 'package:flutter/material.dart';
import 'tela_inicial_view.dart';
import 'meus_dados_view.dart';
import 'config_view.dart';
import 'educacao_view.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaInicialView(),
        ),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EducacaoView(),
        ),
      );
    }

    if (index == 3) {
      return; // já estamos na tela de perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDashboard(),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 76,
          backgroundColor: const Color(0xFF1F5C3A),
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.white24,
          onDestinationSelected: _onItemTapped,
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

                _buildButton(
                  Icons.chat_bubble,
                  "Fale conosco",
                ),

                _buildButton(
                  Icons.menu_book,
                  "Regulamento",
                ),
              ],
            ),

            /// BOTÃO DE CONFIGURAÇÃO
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfiguracaoPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F5C3A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    IconData icon,
    String text, {
    VoidCallback? onTap,
  }) {
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
}