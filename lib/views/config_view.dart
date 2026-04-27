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
      backgroundColor: const Color(0xFFF8FAF9),
      // --- MENU LATERAL (DRAWER) ORIGINAL MANTIDO ---
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

      appBar: AppBar(
        title: const Text(
          "CONFIGURAÇÕES",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F5C3A),
        elevation: 0,
        // --- REMOÇÃO DO BOTÃO DE VOLTAR ---
        automaticallyImplyLeading: false, 
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // --- HEADER CURVADO ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 35, top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1F5C3A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.settings_suggest_rounded, size: 55, color: Colors.white70),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Personalize sua experiência no aplicativo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // --- LISTA DE OPÇÕES ---
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
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
        ],
      ),
    );
  }

  // Widget para os botões da lista
  Widget _buildConfigButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1F5C3A)),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D312E)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  // --- MÉTODOS DO MENU LATERAL (ORIGINAIS) ---
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