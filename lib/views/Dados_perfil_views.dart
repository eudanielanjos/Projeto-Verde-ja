import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    InicioPage(),
    ColetaPage(),
    EducacaoPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        height: 75,
        backgroundColor: const Color(0xFF1F5C3A),
        indicatorColor: Colors.white24,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.location_on, color: Colors.white),
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

////////////////////////////////////////////////////////////
/// 🔹 TELA INÍCIO
////////////////////////////////////////////////////////////

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBasePage(
      title: "Tela Inicial",
      icon: Icons.home,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 TELA COLETA
////////////////////////////////////////////////////////////

class ColetaPage extends StatelessWidget {
  const ColetaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBasePage(
      title: "Defina o local de denúncia",
      icon: Icons.location_on,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 TELA EDUCAÇÃO
////////////////////////////////////////////////////////////

class EducacaoPage extends StatelessWidget {
  const EducacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBasePage(
      title: "Educação Ambiental",
      icon: Icons.school,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 TELA PERFIL
////////////////////////////////////////////////////////////

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBasePage(
      title: "Meu Perfil",
      icon: Icons.person,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 MODELO PADRÃO DE TELA
////////////////////////////////////////////////////////////

Widget _buildBasePage({
  required String title,
  required IconData icon,
}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 90,
              color: const Color(0xFF1F5C3A),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F5C3A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}