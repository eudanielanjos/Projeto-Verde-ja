import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Importações das suas views
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart';
import 'home_view.dart';
import 'tela_inicial_view.dart';
import 'coleta_view.dart';

class HistoricoDenunciasView extends StatefulWidget {
  const HistoricoDenunciasView({super.key});

  @override
  State<HistoricoDenunciasView> createState() => _HistoricoDenunciasViewState();
}

class _HistoricoDenunciasViewState extends State<HistoricoDenunciasView> {
  final Color greenPrimary = const Color(0xFF1F5C3A);

  final List<Map<String, String>> denuncias = [
    {
      "nome": "José Geraldo",
      "titulo": "Lixo em área verde",
      "local": "Parque da Cidade",
      "data": "08/03/2026",
      "motivo": "Descarte irregular de lixo em área protegida. O acúmulo está gerando mau cheiro e atraindo insetos.",
      "status": "Em análise",
      "foto": "assets/images/descarte.png"
    },
    {
      "nome": "José Geraldo",
      "titulo": "Queimada ilegal",
      "local": "Área rural bairro X",
      "data": "05/03/2026",
      "motivo": "Queimada de resíduos orgânicos e plásticos sem autorização durante a noite.",
      "status": "Resolvido",
      "foto": "assets/images/queimada.png"
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Resolvido": return const Color(0xFF59BA15);
      case "Em análise": return Colors.orange;
      case "Recusado": return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Resolvido": return Icons.check_circle_rounded;
      case "Em análise": return Icons.pending_actions_rounded;
      case "Recusado": return Icons.cancel_rounded;
      default: return Icons.info_rounded;
    }
  }

  // --- PAINEL DE INSPEÇÃO (FONTES AUMENTADAS) ---
  void _abrirInspecaoDenuncia(Map<String, String> denuncia) {
    final statusColor = _getStatusColor(denuncia["status"]!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(denuncia["foto"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              denuncia["status"]!.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(denuncia["titulo"]!, 
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: greenPrimary)), // Aumentado
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(denuncia["local"]!, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)), // Aumentado
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.person_outline, "Relator", denuncia["nome"]!)),
                        Expanded(child: _buildInfoRow(Icons.calendar_today_outlined, "Data do Registro", denuncia["data"]!)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.info_outline, "STATUS DO PROTOCOLO", denuncia["status"]!, customColor: statusColor),
                    const SizedBox(height: 30),
                    const Text("DETALHES TÉCNICOS / MOTIVO", 
                      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 13, letterSpacing: 1.1)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7F6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(denuncia["motivo"]!, 
                        style: const TextStyle(fontSize: 17, height: 1.6, color: Colors.black87)), // Aumentado
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? customColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 16, color: greenPrimary), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customColor ?? Colors.black87)), // Aumentado
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
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
                  const Text("Olá, Usuario", 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                  _buildMenuCard(icon: Icons.history_edu, title: "Histórico de Denúncias", onTap: () => Navigator.pop(context)),
                  _buildMenuCard(icon: Icons.person, title: "Perfil", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
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
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F5C3A),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history_edu_rounded, size: 55, color: Colors.white70),
                    SizedBox(height: 10),
                    Text("HISTÓRICO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)), // Aumentado
                    Text("Acompanhe suas solicitações", style: TextStyle(color: Colors.white70, fontSize: 16)), // Aumentado
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
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              itemCount: denuncias.length,
              itemBuilder: (context, index) {
                final item = denuncias[index];
                final statusColor = _getStatusColor(item["status"]!);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), // Aumentado
                    leading: CircleAvatar(
                      radius: 32, // Aumentado
                      backgroundColor: const Color(0xFFF1F5F2),
                      backgroundImage: AssetImage(item["foto"]!),
                    ),
                    title: Text(item["titulo"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D312E))), // Aumentado
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(item["data"]!, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)), // Aumentado
                    ),
                    
                    // --- ALTERAÇÃO: FRASE COM ÍCONE ---
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getStatusIcon(item["status"]!), color: statusColor, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          item["status"]!,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _abrirInspecaoDenuncia(item), 
                  ),
                );
              },
            ),
          ),
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
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          PaintingBinding.instance.imageCache.clear();
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
              const SizedBox(width: 10),
              const Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}