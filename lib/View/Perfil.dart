import 'package:flutter/material.dart';



class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  int _selectedIndex = 0;

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _buildBody(),

    // 🔻 Barra inferior
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

  // Mostra o conteúdo conforme a aba selecionada.
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Tela de Início'));
      case 1:
        return const Center(child: Text('Tela de Busca'));
      case 2:
        return const Center(child: Text('Tela de Educação'));
      case 3:
        return _buildDashboard();
      default:
        return _buildDashboard();
    }
  }

  // conteúdo da "dashboard" (caso índice 0).
  Widget _buildDashboard() {
    return Container(
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
                  Icon(Icons.menu, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 👤 Avatar
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF1F5C3A),
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "MEU PERFIL",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F5C3A),
              ),
            ),

            const SizedBox(height: 30),

            // 📋 Botões
            _buildButton(Icons.person, "Meus dados"),
            _buildButton(Icons.chat_bubble, "Fale conosco"),
            _buildButton(Icons.search, "Histórico de denúncia"),
            _buildButton(Icons.menu_book, "Regulamento"),
             const SizedBox(height: 7),
            _buildLogoutButton(),
            _buildDeleteAccountButton(),
            
          ], 
        ),
      ),
    );
  }
  

   Widget _buildDeleteAccountButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: GestureDetector(
      onTap: () {
        print("Deletar conta pressionado");
      },
      child: Container(
        height: 30,
        alignment: Alignment.center,
        child: const Text(
          "Deletar conta",
          style: TextStyle(
            color: Color(0xFF1F5C3A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
  );
}


   Widget _buildLogoutButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: GestureDetector(
      onTap: () {
        print("Sair da conta pressionado");
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Sair da conta",
          style: TextStyle(
            color: Color(0xFF1F5C3A), // verde escuro
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
  );
}

  // 🔘 Widget padrão dos botões
  Widget _buildButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            const Padding(
              padding: EdgeInsets.only(right: 20),
              
            )
          ],
        ),
      ),
    );
  }
}