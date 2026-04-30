import 'package:flutter/material.dart';

class EducacaoAdminView extends StatefulWidget {
  const EducacaoAdminView({super.key});

  @override
  State<EducacaoAdminView> createState() => _EducacaoAdminViewState();
}

class _EducacaoAdminViewState extends State<EducacaoAdminView> {
  final Color greenDark = const Color(0xFF0D2D19);
  final Color greenPrimary = const Color(0xFF1B4D2E);
  final Color greenAccent = const Color(0xFF8CC63F);
  final Color softGrey = const Color(0xFFF0F4F1);

  final List<Map<String, String>> _videos = [
    {"titulo": "Manual da Reciclagem", "link": "oV3pK3SOjxo", "visualizacoes": "1.2k"},
    {"titulo": "Sustentabilidade Urbana", "link": "GXFXdtycljo", "visualizacoes": "850"},
    {"titulo": "Preservação de Rios", "link": "AiP2qscQUes", "visualizacoes": "2.4k"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      // 🔹 Floating Action Button com Design Orgânico
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _modalFormulario(context),
        backgroundColor: greenPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.video_call_rounded, color: Colors.white, size: 28),
        label: const Text("ADICIONAR", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)
        ),
      ),
      
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 AppBar com Gradiente e Design Curvado
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: greenDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              centerTitle: true,
              title: const Text("GESTÃO DE CONTEÚDO", 
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [greenDark, greenPrimary, greenAccent.withOpacity(0.4)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: 40,
                    child: Icon(Icons.eco, size: 200, color: Colors.white.withOpacity(0.05)),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Lista de Vídeos com Design de Cards Profissionais
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = _videos[index];
                  return _buildVideoCard(index, video);
                },
                childCount: _videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(int index, Map<String, String> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: greenPrimary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Thumbnail" Simulada do Vídeo
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  image: DecorationImage(
                    image: NetworkImage("https://img.youtube.com/vi/${video['link']}/hqdefault.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 60),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: _buildGlassAction(
                  icon: Icons.edit_rounded,
                  onTap: () => _modalFormulario(context, index: index, titulo: video['titulo'], id: video['link']),
                ),
              ),
              Positioned(
                top: 70,
                right: 15,
                child: _buildGlassAction(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  onTap: () => _confirmarExclusao(index),
                ),
              ),
            ],
          ),
          
          // Informações do Vídeo
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video['titulo']!, 
                        style: TextStyle(color: greenDark, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.link_rounded, size: 14, color: greenAccent),
                          const SizedBox(width: 4),
                          Text("ID: ${video['link']}", 
                            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.remove_red_eye_outlined, size: 14, color: greenAccent),
                          const SizedBox(width: 4),
                          Text("${video['visualizacoes']} views", 
                            style: const TextStyle(color: Colors.grey, fontSize: 12)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Botão com Efeito de Vidro (Glassmorphism)
  Widget _buildGlassAction({required IconData icon, required VoidCallback onTap, Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: color == Colors.white ? greenPrimary : color, size: 22),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
          top: 20, left: 25, right: 25
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            Text(index == null ? "🆕 NOVO CONTEÚDO" : "📝 EDITAR VÍDEO", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: greenPrimary)
            ),
            const SizedBox(height: 25),
            _buildTextField(tituloController, "Título do Vídeo", Icons.text_fields_rounded),
            const SizedBox(height: 15),
            _buildTextField(idController, "ID do Vídeo no Youtube", Icons.play_circle_outline),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: greenPrimary,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 5,
              ),
              onPressed: () {
                if (tituloController.text.isNotEmpty && idController.text.isNotEmpty) {
                  setState(() {
                    if (index == null) {
                      _videos.add({"titulo": tituloController.text, "link": idController.text, "visualizacoes": "0"});
                    } else {
                      _videos[index] = {"titulo": tituloController.text, "link": idController.text, "visualizacoes": "..."};
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("FINALIZAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        prefixIcon: Icon(icon, color: greenPrimary),
        filled: true,
        fillColor: softGrey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: greenAccent)),
      ),
    );
  }

  void _confirmarExclusao(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("Excluir conteúdo?"),
        content: const Text("Isso removerá o vídeo permanentemente da lista educativa."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
}