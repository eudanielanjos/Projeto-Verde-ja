import 'package:flutter/material.dart';

// Importações das suas views (certifique-se de que os nomes dos arquivos estão corretos)
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
  // Lista de dados para teste
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
      case "Resolvido": return Icons.check_circle;
      case "Em análise": return Icons.hourglass_top;
      case "Recusado": return Icons.cancel;
      default: return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- MENU LATERAL PADRONIZADO ---
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
            Padding(
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
            ),
          ],
        ),
      ),

      // --- CORPO SEM APPBAR ---
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(120, 159, 130, 1), Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Botão do Menu Flutuante
            Builder(
              builder: (context) => Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ),
            const Text(
              "Histórico de denúncias",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A)),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: denuncias.length,
                itemBuilder: (context, index) {
                  final item = denuncias[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: AssetImage(item["foto"]!)),
                      title: Text(item["titulo"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item["data"]!),
                      trailing: Icon(_getStatusIcon(item["status"]!), color: _getStatusColor(item["status"]!)),
                      onTap: () {
                        // Navegação para a tela de detalhes abaixo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalheDenunciaPage(
                              denuncia: item,
                              statusColor: _getStatusColor(item["status"]!),
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
}

// --- TELA DE DETALHES ---
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
      appBar: AppBar(
        title: const Text("Detalhes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F5C3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD2E1D4), Color(0xFFF2F2F2)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 10),
              CircleAvatar(radius: 60, backgroundImage: AssetImage(denuncia["foto"]!)),
              const SizedBox(height: 15),
              Text(denuncia["nome"]!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A))),
              const SizedBox(height: 25),
              _infoBox("Título", denuncia["titulo"]!),
              _infoBox("Localização", denuncia["local"]!),
              _infoBox("Data da Ocorrência", denuncia["data"]!),
              _infoBox("Descrição do Motivo", denuncia["motivo"]!),
              const SizedBox(height: 30),
              // Badge de Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(denuncia["status"]!.toUpperCase(), 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1F5C3A))),
        ],
      ),
    );
  }
}