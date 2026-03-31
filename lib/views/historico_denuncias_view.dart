import 'package:flutter/material.dart';

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
      "motivo": "Descarte irregular de lixo em área protegida",
      "status": "Em análise",
      "foto": "assets/images/profile1.png"
    },
    {
      "nome": "José Geraldo",
      "titulo": "Queimada ilegal",
      "local": "Área rural bairro X",
      "data": "05/03/2026",
      "motivo": "Queimada de resíduos orgânicos sem autorização",
      "status": "Resolvido",
      "foto": "assets/images/profile1.png"
    },
    {
      "nome": "José Geraldo",
      "titulo": "Poluição no rio",
      "local": "Rio Verde",
      "data": "01/03/2026",
      "motivo": "Despejo de produtos químicos na água",
      "status": "Em análise",
      "foto": "assets/images/profile1.png"
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Resolvido":
        return Colors.green;
      case "Em análise":
        return Colors.orange;
      case "Recusado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Resolvido":
        return Icons.check_circle;
      case "Em análise":
        return Icons.hourglass_top;
      case "Recusado":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Histórico de denúncias",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F5C3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: denuncias.length,
          itemBuilder: (context, index) {
            final denuncia = denuncias[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.fromRGBO(64, 118, 78, 1), Color.fromRGBO(120, 159, 130, 1)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(denuncia["foto"]!),
                ),
                title: Text(
                  denuncia["titulo"]!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  "Data: ${denuncia["data"]} | Local: ${denuncia["local"]}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Icon(
                  _getStatusIcon(denuncia["status"]!),
                  color: _getStatusColor(denuncia["status"]!),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalheDenunciaPage(
                        denuncia: denuncia,
                        statusColor: _getStatusColor(denuncia["status"]!),
                        statusIcon: _getStatusIcon(denuncia["status"]!),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

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
        title: const Text(
          "Detalhes da Denúncia",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white, // Título branco
          ),
        ),
        backgroundColor: const Color(0xFF1F5C3A),
          iconTheme: const IconThemeData(
            color: Colors.white, // 🔥 Botão de voltar branco
          ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(denuncia["foto"]!),
              ),
              const SizedBox(height: 16),
              Text(
                denuncia["nome"]!,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 20),
              _buildInfoCard("Título", denuncia["titulo"]!),
              _buildInfoCard("Local", denuncia["local"]!),
              _buildInfoCard("Data", denuncia["data"]!),
              _buildInfoCard("Motivo", denuncia["motivo"]!),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      denuncia["status"]!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromRGBO(64, 118, 78, 1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}