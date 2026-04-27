import 'package:flutter/material.dart';

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
  final List<Map<String, String>> denuncias = [
    {
      "nome": "José Geraldo",
      "titulo": "Lixo em área verde",
      "local": "Parque da Cidade",
      "data": "08/03/2026",
      "motivo": "Descarte irregular de lixo em área protegida. O acúmulo está gerando mau cheiro e atraindo insetos.",
      "status": "Em análise",
      "foto": "assets/images/profile1.png"
    },
    {
      "nome": "José Geraldo",
      "titulo": "Queimada ilegal",
      "local": "Área rural bairro X",
      "data": "05/03/2026",
      "motivo": "Queimada de resíduos orgânicos e plásticos sem autorização durante a noite.",
      "status": "Resolvido",
      "foto": "assets/images/profile1.png"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      // --- MENU LATERAL ORIGINAL MANTIDO ---
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
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
          // --- HEADER CURVADO (NOVO LAYOUT) ---
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F5C3A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history_edu_rounded, size: 50, color: Colors.white70),
                    SizedBox(height: 10),
                    Text(
                      "HISTÓRICO",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    Text(
                      "Acompanhe suas solicitações",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Botão do Menu
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

          // --- LISTA DE DENÚNCIAS ---
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
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFF1F5F2),
                      backgroundImage: AssetImage(item["foto"]!),
                    ),
                    title: Text(
                      item["titulo"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D312E)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(item["data"]!, style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getStatusIcon(item["status"]!), color: statusColor, size: 28),
                        Text(
                          item["status"]!,
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheDenunciaPage(
                            denuncia: item,
                            statusColor: statusColor,
                            statusIcon: _getStatusIcon(item["status"]!),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Métodos do menu original preservados
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
        onTap: () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
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

// --- TELA DE DETALHES ATUALIZADA ---
class DetalheDenunciaPage extends StatelessWidget {
  final Map<String, String> denuncia;
  final Color statusColor;
  final IconData statusIcon;

  const DetalheDenunciaPage({
    super.key,
    required this.denuncia,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("DETALHES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F5C3A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF1F5C3A),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.white, backgroundImage: AssetImage(denuncia["foto"]!)),
                  const SizedBox(height: 15),
                  Text(denuncia["nome"]!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _infoCard("Título", denuncia["titulo"]!, Icons.title),
                  _infoCard("Localização", denuncia["local"]!, Icons.location_on),
                  _infoCard("Data", denuncia["data"]!, Icons.calendar_today),
                  _infoCard("Descrição", denuncia["motivo"]!, Icons.description),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(denuncia["status"]!.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1F5C3A), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2D312E))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}