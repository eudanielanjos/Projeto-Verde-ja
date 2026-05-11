import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Suas importações existentes
import 'acessibilidade_view.dart'; 
import 'privacidade_view.dart';
import 'idiomas_view.dart';
import 'home_view.dart';
import 'tela_inicial_view.dart';
import 'coleta_view.dart';
import 'educacao_view.dart';
import 'perfil_view.dart';
import 'historico_denuncias_view.dart';
import 'notificacoes_view.dart'; // Certifique-se de que o arquivo se chama assim

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
      
      // --- MENU LATERAL (DRAWER) ---
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 25),
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
                  const SizedBox(height: 10),
                  const Text("Olá, Usuario", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildMenuCard(icon: Icons.home, title: "Início", onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                  }),
                  _buildMenuCard(icon: Icons.calendar_month, title: "Coleta Regular", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                  }),
                  _buildMenuCard(icon: Icons.school, title: "Educação", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                  }),
                  _buildMenuCard(icon: Icons.history_edu, title: "Histórico de Denúncias", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                  }),
                  _buildMenuCard(icon: Icons.person, title: "Perfil", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                  }),
                  _buildMenuCard(icon: Icons.settings, title: "Configurações", onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            _buildSairButton(context),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text("CONFIGURAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F5C3A),
        elevation: 0,
        automaticallyImplyLeading: false, 
        actions: [
          Builder(builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          )),
        ],
      ),

      body: Column(
        children: [
          // Header Curvado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 35, top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1F5C3A),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: const Column(
              children: [
                Icon(Icons.settings_suggest_rounded, size: 55, color: Colors.white70),
                SizedBox(height: 15),
                Text("Personalize sua experiência", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // --- GRADE DE BOTÕES (2 EM 2) ---
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              padding: const EdgeInsets.all(20),
              children: [
                _buildGridButton(
                  icon: Icons.lock_outline, 
                  label: "Privacidade", 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacidadeView()))
                ),
                _buildGridButton(
                  icon: Icons.accessibility_new, 
                  label: "Acessibilidade", 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AcessibilidadeView()))
                ),
                _buildGridButton(
                  icon: Icons.translate, 
                  label: "Idiomas", 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdiomasView()))
                ),
                _buildGridButton(
                  icon: Icons.notifications_none, 
                  label: "Notificações", 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificacoesView()))
                ), 
                _buildGridButton(icon: Icons.dark_mode_outlined, label: "Tema", onTap: () {}),
                _buildGridButton(icon: Icons.help_outline, label: "Suporte", onTap: () {}),
                _buildGridButton(icon: Icons.info_outline, label: "Sobre o App", onTap: () {}),
                _buildGridButton(
                  icon: Icons.delete_forever_outlined, 
                  label: "Excluir Conta", 
                  onTap: () {}, 
                  color: Colors.red.shade50
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTÃO DA GRADE (GRID) ---
  Widget _buildGridButton({required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color != null ? Colors.white.withOpacity(0.5) : const Color(0xFFF1F5F2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1F5C3A), size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D312E)),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares do menu lateral
  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
          }
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14)),
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