import 'package:flutter/material.dart';
import 'denuncia2_view.dart'; // 🔹 Import da segunda tela

class LocalDenunciaPage extends StatelessWidget {
  const LocalDenunciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Colors.black54),
          ),
        ],
      ),

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

              _buildButton(
                icon: Icons.location_on,
                text: "Usar Minha Localização",
                onPressed: () {
                  // Aqui você pode implementar pegar localização
                },
              ),

              const SizedBox(height: 20),

              _buildButton(
                icon: Icons.touch_app,
                text: "Digitar endereço",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Denuncias2(),
                    ),
                  );
                },
              ),

              const Spacer(),

              Image.asset(
                "assets/images/logo.png",
                height: 130,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

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