import 'package:flutter/material.dart';

// Importações das suas views
import 'acessibilidade_view.dart'; 
import 'privacidade_view.dart';
import 'idiomas_view.dart';
import 'home_view.dart';
import 'tela_inicial_view.dart';
import 'coleta_view.dart';
import 'educacao_view.dart';
import 'perfil_view.dart';
import 'historico_denuncias_view.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- MENU LATERAL (DRAWER) PADRONIZADO ---
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Olá, Usuario", 
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildDrawerItem(icon: Icons.home, title: "Início", onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                  }),
                  _buildDrawerItem(icon: Icons.calendar_month, title: "Coleta Regular", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                  }),
                  _buildDrawerItem(icon: Icons.school, title: "Educação", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                  }),
                  _buildDrawerItem(icon: Icons.history_edu, title: "Histórico de Denúncias", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                  }),
                  _buildDrawerItem(icon: Icons.person, title: "Perfil", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                  }),
                  _buildDrawerItem(icon: Icons.settings, title: "Configurações", onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            _buildSairButton(context),
          ],
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(120, 159, 130, 1), // Seu verde padrão
              Colors.white,
            ],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Botão de abrir o Drawer (Hambúrguer)
              Builder(
                builder: (context) => Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 10),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 32, color: Colors.black87),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "CONFIGURAÇÕES",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                  letterSpacing: 1.5,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                "Personalize sua experiência no app",
                style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14),
              ),

              const SizedBox(height: 40),

              // Botões de Configuração Refinados
              _buildConfigButton(
                icon: Icons.lock_outline, 
                label: "Privacidade", 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacidadeView()))
              ),
              _buildConfigButton(
                icon: Icons.accessibility_new, 
                label: "Acessibilidade", 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AcessibilidadeView()))
              ),
              _buildConfigButton(
                icon: Icons.translate, 
                label: "Idiomas e Tradução", 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdiomasView()))
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para os botões da lista de configurações
  Widget _buildConfigButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1F5C3A)),
          ),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E4D3B)),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  // Itens do Drawer (Cards com sombra)
  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF1F5C3A)),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Botão Sair no Drawer
  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false),
        child: Container(
          height: 55,
          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 10),
              Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}