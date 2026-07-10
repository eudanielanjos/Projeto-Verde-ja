import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EducacaoAdminView extends StatefulWidget {
  const EducacaoAdminView({super.key});

  @override
  State<EducacaoAdminView> createState() => _EducacaoAdminViewState();
}

class _EducacaoAdminViewState extends State<EducacaoAdminView> {
  final Color greenPrimary = const Color(0xFF1B4D2E);
  final Color greenDark = const Color(0xFF0D2D19);
  final Color softGrey = const Color(0xFFF5F7F6);

  List<Map<String, String>> _videos = [];

  @override
  void initState() {
    super.initState();
    _carregarVideos();
  }

  Future<void> _carregarVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? videosJson = prefs.getString('lista_videos');
    
    if (videosJson != null) {
      final List<dynamic> decoded = jsonDecode(videosJson);
      setState(() {
        _videos = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    } else {
      // Dados iniciais mockados sem campo de status
      _videos = [
        {"titulo": "Manual da Reciclagem", "link": "oV3pK3SOjxo", "visualizacoes": "1.2k"},
        {"titulo": "Sustentabilidade Urbana", "link": "GXFXdtycljo", "visualizacoes": "850"},
        {"titulo": "Preservação de Rios", "link": "AiP2qscQUes", "visualizacoes": "2.4k"},
      ];
      _salvarVideos();
    }
  }

  Future<void> _salvarVideos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lista_videos', jsonEncode(_videos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _modalFormulario(context),
        backgroundColor: greenPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label: const Text(
          "NOVA MÍDIA", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _videos.isEmpty
                ? const Center(child: Text("Nenhuma mídia educativa cadastrada."))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      return _buildAdminCard(_videos[index], index);
                    },
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 25),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "PAINEL ADMIN: EDUCAÇÃO", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(Map<String, String> item, int index) {
    String titulo = item["titulo"] ?? "Sem Título";
    String linkId = item["link"] ?? "S/ID";
    String views = item["visualizacoes"] ?? "0";

    return Semantics(
      container: true,
      label: "Mídia: $titulo.",
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: Image.network(
                "https://img.youtube.com/vi/$linkId/hqdefault.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie_creation_outlined, color: Colors.grey),
              ),
            ),
          ),
          title: Text(
            titulo, 
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "YouTube ID: $linkId • $views visualizações",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.more_vert_rounded),
          onTap: () => _abrirGerenciamentoMidia(item, index),
        ),
      ),
    );
  }

  void _abrirGerenciamentoMidia(Map<String, String> video, int index) {
    String linkId = video["link"] ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12), 
                width: 40, height: 4, 
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECE9), 
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage("https://img.youtube.com/vi/$linkId/hqdefault.jpg"), 
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(video["titulo"]!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: greenPrimary)),
                    Text("Cliques / Métrica de Views: ${video["visualizacoes"]}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    const Divider(height: 40),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: BorderSide(color: greenPrimary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            icon: Icon(Icons.edit_outlined, color: greenPrimary),
                            label: Text("EDITAR", style: TextStyle(color: greenPrimary, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pop(context);
                              _modalFormulario(context, index: index, titulo: video['titulo'], id: video['link']);
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            label: const Text("DELETAR", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pop(context);
                              _confirmarExclusao(index);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _modalFormulario(BuildContext context, {int? index, String? titulo, String? id}) {
    final TextEditingController tituloController = TextEditingController(text: titulo);
    final TextEditingController idController = TextEditingController(text: id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, top: 16, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(index == null ? "Cadastrar Nova Mídia" : "Editar Detalhes da Mídia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: greenDark)),
            const SizedBox(height: 20),
            _buildTextField(tituloController, "Título do Vídeo Educativo", Icons.text_fields_rounded),
            const SizedBox(height: 12),
            _buildTextField(idController, "ID do Vídeo no YouTube (Ex: oV3pK3SOjxo)", Icons.play_circle_outline),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: greenPrimary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: () {
                final String linkLimpo = idController.text.trim();
                if (tituloController.text.isNotEmpty && linkLimpo.isNotEmpty) {
                  setState(() {
                    if (index == null) {
                      _videos.add({"titulo": tituloController.text, "link": linkLimpo, "visualizacoes": "0"});
                    } else {
                      _videos[index] = {"titulo": tituloController.text, "link": linkLimpo, "visualizacoes": _videos[index]['visualizacoes'] ?? "0"};
                    }
                  });
                  _salvarVideos();
                  Navigator.pop(context);
                }
              },
              child: const Text("Salvar Alterações", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: greenPrimary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF4F7F5),
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  void _confirmarExclusao(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Remover mídia?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: const Text("Esta ação apagará permanentemente o conteúdo educativo e removerá o acesso dos alunos/usuários."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCELAR", style: TextStyle(color: greenPrimary, fontWeight: FontWeight.bold))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              setState(() => _videos.removeAt(index));
              _salvarVideos();
              Navigator.pop(context);
            },
            child: const Text("REMOVER MÍDIA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}