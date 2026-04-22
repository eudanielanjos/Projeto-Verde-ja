import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacidadeView extends StatefulWidget {
  const PrivacidadeView({super.key});

  @override
  State<PrivacidadeView> createState() => _PrivacidadeViewState();
}

class _PrivacidadeViewState extends State<PrivacidadeView> {
  bool localizacao = false;
  bool camera = false;
  bool microfone = false;
  bool historico = false;
  bool relatorios = false;
  bool autenticacao = false;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      localizacao = prefs.getBool('localizacao') ?? false;
      camera = prefs.getBool('camera') ?? false;
      microfone = prefs.getBool('microfone') ?? false;
      historico = prefs.getBool('historico') ?? false;
      relatorios = prefs.getBool('relatorios') ?? false;
      autenticacao = prefs.getBool('autenticacao') ?? false;
    });
  }

  Future salvar(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(chave, valor);
  }

  Future limparDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todos os dados foram apagados."), backgroundColor: Colors.redAccent),
      );
    }
    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("PRIVACIDADE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
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
          // --- HEADER CURVADO ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1F5C3A),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: const Column(
              children: [
                Icon(Icons.security_rounded, size: 50, color: Colors.white70),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Gerencie suas permissões e a segurança dos seus dados.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // --- LISTA DE OPÇÕES ---
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                _buildSectionTitle("Acessos"),
                _buildToggleCard(Icons.location_on_rounded, "Localização", "Uso do GPS no app.", localizacao, (v) {
                  setState(() => localizacao = v);
                  salvar("localizacao", v);
                }),
                _buildToggleCard(Icons.camera_alt_rounded, "Câmera", "Captura de fotos para registros.", camera, (v) {
                  setState(() => camera = v);
                  salvar("camera", v);
                }),
                _buildToggleCard(Icons.mic_rounded, "Microfone", "Gravação de áudio integrada.", microfone, (v) {
                  setState(() => microfone = v);
                  salvar("microfone", v);
                }),

                _buildSectionTitle("Dados e Segurança"),
                _buildToggleCard(Icons.history_rounded, "Histórico", "Salvar atividades recentes.", historico, (v) {
                  setState(() => historico = v);
                  salvar("historico", v);
                }),
                _buildToggleCard(Icons.fingerprint_rounded, "Autenticação", "Camada extra de proteção.", autenticacao, (v) {
                  setState(() => autenticacao = v);
                  salvar("autenticacao", v);
                }),

                const SizedBox(height: 20),
                
                // Botão de Limpar Dados seguindo o estilo
                _buildDangerButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 10),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1.5)),
    );
  }

  Widget _buildToggleCard(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: value ? const Color(0xFF1F5C3A) : Colors.transparent, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1F5C3A),
        secondary: Container(
          height: 45, width: 45,
          decoration: BoxDecoration(color: value ? const Color(0xFFE8F0EA) : const Color(0xFFF1F5F2), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: value ? const Color(0xFF1F5C3A) : Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _buildDangerButton() {
    return InkWell(
      onTap: limparDados,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.red.shade100, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red.shade700),
            const SizedBox(width: 10),
            Text("Apagar todos os dados", style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}