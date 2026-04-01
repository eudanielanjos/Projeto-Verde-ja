import 'package:flutter/material.dart';

class AdminMenuView extends StatelessWidget {
  const AdminMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greenPrimary = Color(0xFF1B4D2E);

    return Scaffold(
      backgroundColor: greenPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/images/logo2.png', height: 120),

              
              const SizedBox(height: 40),
              const Text('Olá, Administrador', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
              
              const SizedBox(height: 30),
              _menuItem(context, 'Gestão de coletas', '/home_visitante'),
              
              // 🔹 ROTA CONECTADA À TELA EDUCATIVA
              _menuItem(context, 'Área educativa', '/educacaoAdmin'), 
              
              _menuItem(context, 'Fale conosco', '/home_visitante'),
              _menuItem(context, 'Histórico de denúncias', '/historicoAdmin'),

              const SizedBox(height: 60),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                child: const Text('Sair da conta', 
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(color: const Color(0xFFE9EFEC), borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF1B4D2E), fontSize: 18, fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF1B4D2E), size: 18),
          ],
        ),
      ),
    );
  }
}