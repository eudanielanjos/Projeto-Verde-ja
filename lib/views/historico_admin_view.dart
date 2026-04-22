import 'package:flutter/material.dart';

class HistoricoAdminView extends StatefulWidget {
  const HistoricoAdminView({super.key});

  @override
  State<HistoricoAdminView> createState() => _HistoricoAdminViewState();
}

class _HistoricoAdminViewState extends State<HistoricoAdminView> {
  String _filtroSelecionado = "Todas";

  // Simulação de base de dados
  final List<Map<String, dynamic>> _denuncias = [
    {
      "id": 1,
      "nome": "José Geraldo",
      "titulo": "Lixo em área verde",
      "local": "Parque da Cidade",
      "data": "08/03/2026",
      "motivo": "Descarte irregular de lixo em área protegida. O acúmulo está gerando mau cheiro e atraindo insetos nocivos à fauna local.",
      "status": "Em análise",
      "foto": "assets/images/profile1.png"
    },
    {
      "id": 2,
      "nome": "Maria Silva",
      "titulo": "Queimada ilegal",
      "local": "Área rural bairro X",
      "data": "05/03/2026",
      "motivo": "Queimada de resíduos orgânicos e plásticos sem autorização durante o período noturno, causando fumaça densa.",
      "status": "Resolvido",
      "foto": "assets/images/profile1.png"
    },
  ];

  List<Map<String, dynamic>> get _denunciasFiltradas {
    if (_filtroSelecionado == "Todas") return _denuncias;
    return _denuncias.where((d) => d["status"] == _filtroSelecionado).toList();
  }

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
      backgroundColor: const Color(0xFFF5F7F6),
      body: Column(
        children: [
          // --- HEADER ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: greenPrimary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text("PAINEL ADMIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        ),
                        _buildCounterChip(),
                      ],
                    ),
                  ),
                  Container(
                    height: 65,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      children: [
                        _buildFilterPill("Todas", Icons.all_inclusive),
                        _buildFilterPill("Em análise", Icons.hourglass_empty),
                        _buildFilterPill("Resolvido", Icons.check_circle_outline),
                        _buildFilterPill("Recusado", Icons.highlight_off),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // --- LISTA ---
          Expanded(
            child: _denunciasFiltradas.isEmpty 
              ? const Center(child: Text("Nenhuma ocorrência encontrada.")) 
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _denunciasFiltradas.length,
                  itemBuilder: (context, index) => _buildAdminCard(_denunciasFiltradas[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, IconData icon) {
    bool isSelected = _filtroSelecionado == label;
    return GestureDetector(
      onTap: () => setState(() => _filtroSelecionado = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF1B4D2E) : Colors.white),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF1B4D2E) : Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
      child: Text("${_denuncias.length} Total", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(radius: 25, backgroundImage: AssetImage(item["foto"])),
        title: Text(item["titulo"], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item["nome"]} • ${item["data"]}"),
        trailing: Icon(Icons.circle, color: _getStatusColor(item["status"]), size: 12),
        onTap: () => _abrirGestaoDenuncia(item),
      ),
    );
  }

  void _abrirGestaoDenuncia(Map<String, dynamic> denuncia) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            const Text("Detalhes da Ocorrência", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
            const Divider(height: 30),
            
            // INFORMAÇÕES DA DENÚNCIA
            _infoRow(Icons.person, "Relator", denuncia["nome"]),
            _infoRow(Icons.calendar_today, "Data do Registro", denuncia["data"]),
            _infoRow(Icons.location_on, "Localização", denuncia["local"]),
            _infoRow(Icons.description, "Descrição do Motivo", denuncia["motivo"]),
            
            const Spacer(),
            const Text("ALTERAR STATUS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusButton("Em análise", Colors.orange, denuncia),
                _statusButton("Resolvido", Colors.green, denuncia),
                _statusButton("Recusado", Colors.red, denuncia),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1B4D2E), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusButton(String status, Color color, Map<String, dynamic> denuncia) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            setState(() {
              int idx = _denuncias.indexWhere((e) => e["id"] == denuncia["id"]);
              _denuncias[idx]["status"] = status;
            });
            Navigator.pop(context);
          },
          child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}