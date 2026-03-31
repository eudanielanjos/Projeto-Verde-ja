import 'package:flutter/material.dart';
import 'acessibilidade_view.dart'; 
import 'privacidade_view.dart';
import 'idiomas_view.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E7F6B),
              Color(0xFFEAEAEA),
              Color(0xFFEAEAEA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // 🔙 Barra superior
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.arrow_back, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "CONFIGURAÇÕES",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 40),

              _buildButton(Icons.lock, "Privacidade"),
              _buildButton(Icons.accessibility, "Acessibilidade"),
              _buildButton(Icons.language, "Idiomas e Tradução"),
            ],
          ),
        ),
      ),

      // 🔻 Barra inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: NavigationBar(
          height: 76,
          backgroundColor: const Color(0xFF1F5C3A),
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.white24,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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

  // 🔘 Botões de configuração
  Widget _buildButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        height: 60,

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 133, 105),
          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(14),

            onTap: () {

              // 🔐 Tela de Privacidade
              if (label == "Privacidade") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacidadeView(),
                  ),
                );
              }

              // ♿ Tela de Acessibilidade
              if (label == "Acessibilidade") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AcessibilidadeView(),
                  ),
                );
              }

              // 🌎 Tela de Idiomas
              if (label == "Idiomas e Tradução") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IdiomasView(),
                  ),
                );
              }
            },

            child: ListTile(
              leading: Icon(
                icon,
                color: const Color.fromARGB(255, 247, 247, 247),
              ),

              title: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}