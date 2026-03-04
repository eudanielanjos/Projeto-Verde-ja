import 'package:flutter/material.dart';

class AcessibilidadeView extends StatefulWidget {
  const AcessibilidadeView({super.key});

  @override
  State<AcessibilidadeView> createState() => _AcessibilidadeViewState();
}

class _AcessibilidadeViewState extends State<AcessibilidadeView> {
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.black54),
                    // Icon(Icons.menu, color: Colors.black54),
                  ],
                ),
              ),
 
              const SizedBox(height: 35),

              const Text(
                "ACESSIBILIDADE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                ),
              ),

               const SizedBox(height: 45),

              // 📋 Botões
              _buildButton(Icons.location_on, "Informações de localização"),
              _buildButton(Icons.remove_red_eye, "Modo Daltonismo"),
              _buildButton(Icons.record_voice_over, "Leitor de Tela"),
              _buildButton(Icons.text_fields, "Tamanho da Fonte"),
            ],
          ),
        ),
      ),
      // 🔻 Barra inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
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

  Widget _buildButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 133, 105),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 247, 247, 247)),
          title: Text(label, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          onTap: () {},
        ),
      ),
    );
  }
}