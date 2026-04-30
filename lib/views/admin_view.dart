import 'package:flutter/material.dart';

class AdminMenuView extends StatelessWidget {
  const AdminMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greenDark = Color(0xFF133621);
    const Color greenPrimary = Color(0xFF1B4D2E);
    const Color softWhite = Color(0xFFF8FAFB);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [greenDark, greenPrimary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo2.png', height: 90),
              
              const SizedBox(height: 20),
              const Text(
                'Olá, Administrador',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: softWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      // 🔹 GRID COM 2 EM CIMA E 2 EM BAIXO
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2, // 2 colunas
                          crossAxisSpacing: 15, // Espaço lateral entre botões
                          mainAxisSpacing: 15, // Espaço vertical entre botões
                          childAspectRatio: 1.1, // Ajusta a proporção (mais quadrado ou retângulo)
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(context, 'Gestão de\ncoletas', Icons.recycling, '/home_visitante'),
                            _buildGridItem(context, 'Área\neducativa', Icons.school, '/educacaoAdmin'),
                            _buildGridItem(context, 'Fale\nconosco', Icons.chat_bubble, '/home_visitante'),
                            _buildGridItem(context, 'Histórico de\ndenúncias', Icons.history, '/historicoAdmin'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                        child: const Text(
                          'Sair da conta',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para os botões em formato de Card (Grid)
  Widget _buildGridItem(BuildContext context, String title, IconData icon, String route) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4D2E).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF1B4D2E), size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1B4D2E),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}