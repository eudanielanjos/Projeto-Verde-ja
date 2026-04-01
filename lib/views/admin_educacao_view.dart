import 'package:flutter/material.dart';

class EducacaoAdminView extends StatefulWidget {
  const EducacaoAdminView({super.key});

  @override
  State<EducacaoAdminView> createState() => _EducacaoAdminViewState();
}

class _EducacaoAdminViewState extends State<EducacaoAdminView> {
  final Color greenPrimary = const Color(0xFF1B4D2E);
  final Color greenAccent = const Color(0xFF7BB132);
  final Color cardWhite = const Color(0xFFF8FAF9);

  // Lista de vídeos
  final List<Map<String, String>> _videos = [
    {"titulo": "Como Reciclar", "link": "oV3pK3SOjxo"},
    {"titulo": "Sustentabilidade", "link": "GXFXdtycljo"},
    {"titulo": "Meio Ambiente", "link": "AiP2qscQUes"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PAINEL DE VÍDEOS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      
      // 🔹 BOTÃO DE ADICIONAR MELHORADO
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: greenAccent,
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("ADICIONAR VÍDEO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _modalFormulario(context),
      ),

      body: Column(
        children: [
          _buildHeaderInfo(),
          Expanded(
            child: _videos.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return _buildEnhancedVideoCard(index, video['titulo']!, video['link']!);
                  },
                ),
          ),
        ],
      ),
    );
  }

  // 🔹 WIDGET: CABEÇALHO INFORMATIVO
  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          const Icon(Icons.settings_suggest_outlined, color: Colors.white54, size: 40),
          const SizedBox(height: 10),
          Text(
            "Gerencie os conteúdos educativos da plataforma. Use IDs válidos do YouTube para garantir a reprodução.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white12, thickness: 1),
        ],
      ),
    );
  }

  // 🔹 WIDGET: CARD DE VÍDEO CUSTOMIZADO
  Widget _buildEnhancedVideoCard(int index, String titulo, String id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFF7BB132), width: 6)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: greenPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.play_circle_outline, color: greenPrimary, size: 30),
            ),
            title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, color: greenPrimary, fontSize: 17)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text("ID: $id", style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.mode_edit_outline_outlined, color: Colors.blueAccent),
                  onPressed: () => _modalFormulario(context, index: index, titulo: titulo, id: id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                  onPressed: () => _confirmarExclusao(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 ESTADO VAZIO
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_collection_outlined, color: Colors.white24, size: 80),
          SizedBox(height: 10),
          Text("Nenhum vídeo cadastrado.", style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }

  // 🔹 LÓGICA: CONFIRMAR EXCLUSÃO
  void _confirmarExclusao(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Excluir Vídeo?"),
        content: const Text("Essa ação não poderá ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() => _videos.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("EXCLUIR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🔹 MODAL: FORMULÁRIO ESTILIZADO
  void _modalFormulario(BuildContext context, {int? index, String? titulo, String? id}) {
    final TextEditingController tituloController = TextEditingController(text: titulo);
    final TextEditingController idController = TextEditingController(text: id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 30, left: 25, right: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == null ? "🚀 Novo Conteúdo" : "📝 Editar Conteúdo", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: greenPrimary),
            ),
            const SizedBox(height: 25),
            _buildTextField(controller: tituloController, label: "Título chamativo", icon: Icons.title),
            const SizedBox(height: 15),
            _buildTextField(controller: idController, label: "ID do Vídeo (Youtube)", icon: Icons.link, hint: "Ex: oV3pK3SOjxo"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                ),
                onPressed: () {
                  if (tituloController.text.isNotEmpty && idController.text.isNotEmpty) {
                    setState(() {
                      if (index == null) {
                        _videos.add({"titulo": tituloController.text, "link": idController.text});
                      } else {
                        _videos[index] = {"titulo": tituloController.text, "link": idController.text};
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("SALVAR CONTEÚDO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, String? hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: greenPrimary),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: greenAccent, width: 2)),
      ),
    );
  }
}