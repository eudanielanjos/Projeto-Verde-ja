import 'package:flutter/material.dart';

class HistoricoAdminView extends StatefulWidget {
  const HistoricoAdminView({super.key});

  @override
  State<HistoricoAdminView> createState() => _HistoricoAdminViewState();
}

class _HistoricoAdminViewState extends State<HistoricoAdminView> {
  // Lista de denúncias (Simulando banco de dados)
  final List<Map<String, dynamic>> _denuncias = [
    {
      "id": 1,
      "nome": "José Geraldo",
      "titulo": "Lixo em área verde",
      "local": "Parque da Cidade",
      "data": "08/03/2026",
      "motivo": "Descarte irregular de lixo em área protegida. O acúmulo está gerando mau cheiro e atraindo insetos.",
      "status": "Em análise",
      "foto": "assets/images/profile1.png"
    },
    {
      "id": 2,
      "nome": "Maria Silva",
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

  @override
  Widget build(BuildContext context) {
    const Color greenPrimary = Color(0xFF1B4D2E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("Painel de Denúncias", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: greenPrimary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: greenPrimary.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, color: greenPrimary),
                const SizedBox(width: 10),
                Text("Total de ocorrências: ${_denuncias.length}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: greenPrimary)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _denuncias.length,
              itemBuilder: (context, index) {
                final item = _denuncias[index];
                return _buildAdminDenunciaCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDenunciaCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(radius: 25, backgroundImage: AssetImage(item["foto"])),
        title: Text(item["titulo"], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item["nome"]} • ${item["data"]}"),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(item["status"]).withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(item["status"], 
                style: TextStyle(color: _getStatusColor(item["status"]), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _abrirGestaoDenuncia(item, index),
      ),
    );
  }

  // 🔹 TELA DE GESTÃO (DETALHES + AÇÕES)
  void _abrirGestaoDenuncia(Map<String, dynamic> denuncia, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  const Text("Gestão da Ocorrência", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(height: 40),
                  
                  _infoRow("Relator", denuncia["nome"]),
                  _infoRow("Título", denuncia["titulo"]),
                  _infoRow("Local", denuncia["local"]),
                  _infoRow("Descrição", denuncia["motivo"]),
                  
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ALTERAR STATUS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  const SizedBox(height: 15),
                  
                  // Botões de Ação de Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusActionButton("Em análise", Colors.orange, denuncia, index),
                      _statusActionButton("Resolvido", Colors.green, denuncia, index),
                      _statusActionButton("Recusado", Colors.red, denuncia, index),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text("EXCLUIR DENÚNCIA", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        setState(() => _denuncias.removeAt(index));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _statusActionButton(String status, Color color, Map<String, dynamic> denuncia, int index) {
    bool isCurrent = denuncia["status"] == status;
    return InkWell(
      onTap: () {
        setState(() => _denuncias[index]["status"] = status);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrent ? color : Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isCurrent ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}