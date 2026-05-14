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
  // Dados simulados que podem ser alterados
  String telefone = "+55 11 99999-9999";
  String endereco = "Rua Exemplo, 123 - São Paulo, SP";
  String nome = "Usuário Admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
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
                    _buildAvatarComFoto(),
                    const SizedBox(height: 15),
                    Text(
                      nome,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "admin123@email.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
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
                  value: telefone,
                ),
                _buildInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "Endereço",
                  value: endereco,
                ),
                _buildInfoCard(
                  icon: Icons.lock_outline_rounded,
                  title: "Senha",
                  value: "********",
                ),
                const SizedBox(height: 20),
                
                // Botão Editar que abre o Modal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirModalEdicao(context),
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

  // --- FUNCIONALIDADE: MODAL DE EDIÇÃO ---
  void _abrirModalEdicao(BuildContext context) {
    // Controladores para pegar os novos textos
    final teledoneController = TextEditingController(text: telefone);
    final enderecoController = TextEditingController(text: endereco);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 25,
            right: 25,
            top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("Editar Informações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A))),
              const SizedBox(height: 25),
              _buildCampoEdicao(label: "Telefone", controller: teledoneController, icon: Icons.phone),
              const SizedBox(height: 15),
              _buildCampoEdicao(label: "Endereço", controller: enderecoController, icon: Icons.map),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    telefone = teledoneController.text;
                    endereco = enderecoController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5C3A),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("SALVAR ALTERAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildAvatarComFoto() {
    return Stack(
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
    );
  }

  Widget _buildCampoEdicao({required String label, required TextEditingController controller, required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1F5C3A)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF1F5C3A)), borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F2), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: const Color(0xFF1F5C3A)),
        ),
        title: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF2D312E), fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- MENU LATERAL (DRAWER) ---
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
                const Text("Olá, Usuario", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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