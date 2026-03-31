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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          
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
              Color(0xFFD2E1D4), 
              Color(0xFFF2F2F2),
              Color(0xFFF2F2F2),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 🔹 Centraliza o conteúdo verticalmente
            children: [
              const Spacer(flex: 2), // Empurra o conteúdo para o centro real

              /// 🔹 TÍTULO EM DESTAQUE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Defina o local de denúncia:",
                  style: TextStyle(
                    fontSize: 26, // Aumentado para destaque
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F5C3A),
                    letterSpacing: -0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              /// 🔹 BOTÕES CENTRALIZADOS
              _buildCenterButton(
                context: context,
                icon: Icons.my_location_rounded,
                text: "Usar Minha Localização",
                isPrimary: true,
                onPressed: () {
                  // Lógica de GPS
                },
              ),

              const SizedBox(height: 20),

              _buildCenterButton(
                context: context,
                icon: Icons.keyboard_rounded,
                text: "Digitar endereço",
                isPrimary: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Denuncias2()),
                  );
                },
              ),

              const Spacer(flex: 3), // Espaço maior embaixo para equilibrar o visual

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 WIDGET DE BOTÃO OTIMIZADO PARA O CENTRO
  Widget _buildCenterButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // Responsivo
      height: 70, // Mais alto para facilitar o clique
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPrimary 
                ? const Color(0xFF59BA15).withOpacity(0.3) 
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF59BA15) : const Color(0xFF63866C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}