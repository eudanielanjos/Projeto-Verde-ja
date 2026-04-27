import 'package:flutter/material.dart';

class IdiomasView extends StatefulWidget {
  const IdiomasView({super.key});

  @override
  State<IdiomasView> createState() => _IdiomasViewState();
}

class _IdiomasViewState extends State<IdiomasView> {
  String idiomaSelecionado = "Português";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("IDIOMAS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F5C3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1F5C3A),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: const Column(
              children: [
                Icon(Icons.translate_rounded, size: 50, color: Colors.white70),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Selecione o idioma principal para navegar no aplicativo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                _buildIdioma("Português", "🇧🇷", "Português (Brasil)"),
                _buildIdioma("English", "🇺🇸", "English (United States)"),
                _buildIdioma("Español", "🇪🇸", "Español (España)"),
                _buildIdioma("Français", "🇫🇷", "Français (France)"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdioma(String idioma, String bandeira, String subtitulo) {
    bool selecionado = idiomaSelecionado == idioma;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: selecionado ? const Color(0xFF1F5C3A) : Colors.transparent, width: 2),
        boxShadow: [BoxShadow(color: selecionado ? const Color(0xFF1F5C3A).withOpacity(0.1) : Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: InkWell(
        onTap: () => setState(() => idiomaSelecionado = idioma),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 50, width: 50,
                decoration: BoxDecoration(color: const Color(0xFFF1F5F2), borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                child: Text(bandeira, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(idioma, style: TextStyle(color: selecionado ? const Color(0xFF1F5C3A) : const Color(0xFF2D312E), fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(subtitulo, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ],
                ),
              ),
              Icon(selecionado ? Icons.check_circle_rounded : Icons.circle_outlined, color: selecionado ? const Color(0xFF1F5C3A) : Colors.grey.shade300, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}