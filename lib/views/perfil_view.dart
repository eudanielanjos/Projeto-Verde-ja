import 'package:flutter/material.dart';
import 'package:flutter_app/views/coleta_view.dart';
import 'tela_inicial_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'educacao_view.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9), // Fundo levemente acinzentado
      endDrawer: _buildMenuDrawer(context),
      body: Column(
        children: [
          // --- HEADER CURVADO ---
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F5C3A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 52,
                            backgroundColor: Color(0xFFF1F5F2),
                            child: Icon(Icons.person, size: 65, color: Color(0xFF1F5C3A)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFF1F5C3A),
                            child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Usuário Admin",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "admin123@email.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Botão do Menu (Substituindo o AppBar)
              Positioned(
                top: 40,
                right: 15,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ],
          ),

          // --- CONTEÚDO (CARDS) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                _buildInfoCard(
                  icon: Icons.phone_android_rounded,
                  title: "Telefone",
                  value: "+55 11 99999-9999",
                ),
                _buildInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "Endereço",
                  value: "Rua Exemplo, 123 - São Paulo, SP",
                ),
                _buildInfoCard(
                  icon: Icons.lock_outline_rounded,
                  title: "Senha",
                  value: "********",
                ),
                const SizedBox(height: 20),
                // Botão Editar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                    label: const Text("EDITAR PERFIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C3A),
                      fixedSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Novo Widget de Card Padronizado
  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: const Color(0xFF1F5C3A)),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Color(0xFF2D312E), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- MENU LATERAL (DRAWER) MANTIDO ---
  Widget _buildMenuDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Olá, Usuario",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                _buildMenuCard(icon: Icons.calendar_today, title: "Coleta Regular", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                }),
                _buildMenuCard(icon: Icons.school, title: "Educação", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                }),
                _buildMenuCard(icon: Icons.person, title: "Perfil", onTap: () => Navigator.pop(context)),
                _buildMenuCard(icon: Icons.history, title: "Histórico de Denúncias", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                }),
                _buildMenuCard(icon: Icons.settings, title: "Configurações", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage()));
                }),
              ],
            ),
          ),
          _buildSairButton(context),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF1F5C3A)),
            title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false),
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