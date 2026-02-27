import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocalDenunciaPage(),
    );
  }
}

class LocalDenunciaPage extends StatelessWidget {
  const LocalDenunciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // 🔹 APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black54),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Colors.black54),
          ),
        ],
      ),

      // 🔹 FUNDO EM GRADIENTE (IGUAL PERFIL)
      body: Container(
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
          child: Column(
            children: [

              const SizedBox(height: 60),

              // 🔹 TÍTULO
              const Text(
                "Defina o local de denúncia:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 35),

              // 🔹 BOTÃO 1
              _buildButton(
                icon: Icons.location_on,
                text: "Usar Minha Localização",
                onPressed: () {},
              ),

              const SizedBox(height: 20),

              // 🔹 BOTÃO 2
              _buildButton(
                icon: Icons.touch_app,
                text: "Digitar endereço",
                onPressed: () {},
              ),

              const Spacer(),

              // 🔹 LOGO (se quiser manter imagem)
              Image.asset(
                "assets/images/logo.png",
                height: 130,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // 🔹 NAVIGATION BAR (IGUAL PERFIL)
      bottomNavigationBar: NavigationBar(
        height: 75,
        backgroundColor: const Color(0xFF1F5C3A),
        indicatorColor: Colors.white24,
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

  // 🔹 BOTÃO PADRÃO
  Widget _buildButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 310,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E7F6B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}