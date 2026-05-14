import 'package:flutter/material.dart';

class HistoricoAdminView extends StatefulWidget {
  const HistoricoAdminView({super.key});

  @override
  State<HistoricoAdminView> createState() => _HistoricoAdminViewState();
}

class _HistoricoAdminViewState extends State<HistoricoAdminView> {
  final Color greenPrimary = const Color(0xFF1B4D2E);
  final Color greenAccent = const Color(0xFF59BA15);
  String _filtroSelecionado = "Todas";

  final List<Map<String, dynamic>> _denuncias = [
    {
      "id": "ORD-2026-001",
      "nome": "José Geraldo",
      "titulo": "Lixo em área verde",
      "local": "Parque da Cidade",
      "data": "08/03/2026",
      "motivo": "Descarte irregular de entulho e móveis velhos em área protegida. O acúmulo está gerando mau cheiro e atraindo insetos nocivos.",
      "status": "Em análise",
      "foto_perfil": "https://i.pravatar.cc/150?img=11",
      "foto_evidencia": "https://images.unsplash.com/photo-1530587191325-3db32d826c18?q=80&w=800",
    },
    {
      "id": "ORD-2026-002",
      "nome": "Maria Silva",
      "titulo": "Queimada ilegal",
      "local": "Área rural bairro X",
      "data": "05/03/2026",
      "motivo": "Queimada de resíduos orgânicos e plásticos sem autorização durante o período noturno, causando fumaça densa.",
      "status": "Resolvido",
      "foto_perfil": "https://i.pravatar.cc/150?img=5",
      "foto_evidencia": "https://images.unsplash.com/photo-1565011523534-747a8601f10a?q=80&w=800",
    },
  ];

  List<Map<String, dynamic>> get _denunciasFiltradas {
    if (_filtroSelecionado == "Todas") return _denuncias;
    return _denuncias.where((d) => d["status"] == _filtroSelecionado).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Resolvido": return greenAccent;
      case "Em análise": return Colors.orange;
      case "Recusado": return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: Column(
        children: [
          _buildHeader(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: greenPrimary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
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
                    child: Text("PAINEL ADMIN", 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ),
                ],
              ),
            ),
            SizedBox(
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
            Icon(icon, size: 16, color: isSelected ? greenPrimary : Colors.white),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? greenPrimary : Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(item["foto_perfil"])),
        title: Text(item["titulo"], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item["nome"]} • ${item["data"]}"),
        trailing: Icon(Icons.circle, color: _getStatusColor(item["status"]), size: 12),
        onTap: () => _abrirDetalhesDenuncia(item),
      ),
    );
  }

  void _abrirDetalhesDenuncia(Map<String, dynamic> denuncia) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[200], borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: NetworkImage(denuncia["foto_evidencia"]), fit: BoxFit.cover),
                      ),
                      child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.all(12), child: _statusBadge(denuncia["status"]))),
                    ),
                    const SizedBox(height: 20),
                    Text(denuncia["titulo"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1B4D2E))),
                    Text(denuncia["local"], style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    const Divider(height: 40),
                    
                    // --- GRID DE INFORMAÇÕES COM STATUS INCLUÍDO ---
                    Row(
                      children: [
                        Expanded(child: _infoDetail(Icons.person_outline, "Relator", denuncia["nome"])),
                        Expanded(child: _infoDetail(Icons.calendar_today_outlined, "ID Registro", denuncia["id"])),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _infoDetail(
                      Icons.info_outline, 
                      "STATUS ATUAL", 
                      denuncia["status"], 
                      customColor: _getStatusColor(denuncia["status"])
                    ),
                    
                    const SizedBox(height: 25),
                    const Text("MOTIVO DA OCORRÊNCIA", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 11, letterSpacing: 1.1)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7F6), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
                      child: Text(denuncia["motivo"], style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                    ),
                    
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenPrimary, 
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                        elevation: 0,
                      ),
                      onPressed: () => _mostrarMenuStatus(denuncia),
                      child: const Text("GERENCIAR STATUS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
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

  void _mostrarMenuStatus(Map<String, dynamic> denuncia) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ALTERAR STATUS PARA:", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            _statusOption(Icons.hourglass_empty, "Em análise", Colors.orange, denuncia),
            _statusOption(Icons.check_circle_outline, "Resolvido", greenAccent, denuncia),
            _statusOption(Icons.highlight_off, "Recusado", Colors.red, denuncia),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(IconData icon, String label, Color color, Map<String, dynamic> denuncia) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        setState(() {
          int idx = _denuncias.indexWhere((e) => e["id"] == denuncia["id"]);
          _denuncias[idx]["status"] = label;
        });
        Navigator.pop(context); 
        Navigator.pop(context); 
      },
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // --- HELPER COM SUPORTE A COR CUSTOMIZADA ---
  Widget _infoDetail(IconData icon, String label, String value, {Color? customColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 14, color: greenPrimary), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: customColor ?? Colors.black87)),
      ],
    );
  }
}