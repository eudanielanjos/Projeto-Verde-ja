import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacidadeView extends StatefulWidget {
  const PrivacidadeView({super.key});

  @override
  State<PrivacidadeView> createState() => _PrivacidadeViewState();
}

class _PrivacidadeViewState extends State<PrivacidadeView> {
  bool localizacao = false;
  bool compartilhamento = false;
  bool historico = false;
  bool notificacoes = false;
  bool camera = false;
  bool microfone = false;
  bool autenticacao = false;
  bool relatorios = false;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      localizacao = prefs.getBool('localizacao') ?? false;
      compartilhamento = prefs.getBool('compartilhamento') ?? false;
      historico = prefs.getBool('historico') ?? false;
      notificacoes = prefs.getBool('notificacoes') ?? false;
      camera = prefs.getBool('camera') ?? false;
      microfone = prefs.getBool('microfone') ?? false;
      autenticacao = prefs.getBool('autenticacao') ?? false;
      relatorios = prefs.getBool('relatorios') ?? false;
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
        const SnackBar(
          content: Text("Todos os dados foram apagados."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(120, 159, 130, 1),
              Colors.white,
            ],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- BARRA SUPERIOR COM BOTÃO VOLTAR ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // --- CABEÇALHO ---
              const Icon(Icons.security_outlined, size: 50, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(height: 10),
              const Text(
                "PRIVACIDADE",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  letterSpacing: 1.2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Text(
                  "Gerencie suas permissões e a segurança dos seus dados.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),

              // --- LISTA DE OPÇÕES ---
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildSectionTitle("Acessos do Dispositivo"),
                        _tile(Icons.location_on_outlined, "Localização", "Uso do GPS no app.", localizacao, (v) {
                          setState(() => localizacao = v);
                          salvar("localizacao", v);
                        }),
                        _tile(Icons.camera_alt_outlined, "Câmera", "Captura de fotos para denúncias.", camera, (v) {
                          setState(() => camera = v);
                          salvar("camera", v);
                        }),
                        _tile(Icons.mic_none_outlined, "Microfone", "Gravação de áudio integrada.", microfone, (v) {
                          setState(() => microfone = v);
                          salvar("microfone", v);
                        }),
                        
                        _buildSectionTitle("Preferências de Dados"),
                        _tile(Icons.history, "Histórico", "Salvar suas atividades recentes.", historico, (v) {
                          setState(() => historico = v);
                          salvar("historico", v);
                        }),
                        _tile(Icons.analytics_outlined, "Relatórios", "Envio de dados anônimos.", relatorios, (v) {
                          setState(() => relatorios = v);
                          salvar("relatorios", v);
                        }),
                        
                        _buildSectionTitle("Segurança"),
                        _tile(Icons.verified_user_outlined, "Autenticação Extra", "Camada extra de proteção.", autenticacao, (v) {
                          setState(() => autenticacao = v);
                          salvar("autenticacao", v);
                        }),

                        const SizedBox(height: 30),

                        // --- BOTÃO DE APAGAR DADOS ---
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: InkWell(
                            onTap: limparDados,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.red.shade100),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_sweep_outlined, color: Colors.red.shade700),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Apagar todos os meus dados",
                                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String description, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF1F5C3A),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1F5C3A), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F5C3A)),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}