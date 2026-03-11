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

  // ===============================
  // CARREGAR CONFIGURAÇÕES
  // ===============================

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

  // ===============================
  // SALVAR CONFIGURAÇÕES
  // ===============================

  Future salvar(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(chave, valor);
  }

  // ===============================
  // LIMPAR DADOS
  // ===============================

  Future limparDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Todos os dados foram apagados.")),
    );

    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        // MESMO FUNDO DA ACESSIBILIDADE
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5E7F6B),
              Colors.grey.shade200,
              Colors.grey.shade200,
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "PRIVACIDADE",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F5C3A),
                  ),
                ),

                const SizedBox(height: 30),

                _tile(
                  Icons.location_on,
                  "Localização",
                  "Permite que o aplicativo utilize sua localização.",
                  localizacao,
                      (v) {
                    setState(() => localizacao = v);
                    salvar("localizacao", v);
                  },
                ),

                _tile(
                  Icons.share,
                  "Compartilhamento de Dados",
                  "Autoriza compartilhar dados para melhorar serviços.",
                  compartilhamento,
                      (v) {
                    setState(() => compartilhamento = v);
                    salvar("compartilhamento", v);
                  },
                ),

                _tile(
                  Icons.history,
                  "Histórico de Atividades",
                  "Salva ações realizadas dentro do aplicativo.",
                  historico,
                      (v) {
                    setState(() => historico = v);
                    salvar("historico", v);
                  },
                ),

                _tile(
                  Icons.notifications,
                  "Notificações",
                  "Permite receber notificações do aplicativo.",
                  notificacoes,
                      (v) {
                    setState(() => notificacoes = v);
                    salvar("notificacoes", v);
                  },
                ),

                _tile(
                  Icons.camera_alt,
                  "Acesso à Câmera",
                  "Permite usar a câmera dentro do aplicativo.",
                  camera,
                      (v) {
                    setState(() => camera = v);
                    salvar("camera", v);
                  },
                ),

                _tile(
                  Icons.mic,
                  "Acesso ao Microfone",
                  "Permite gravar áudio dentro do aplicativo.",
                  microfone,
                      (v) {
                    setState(() => microfone = v);
                    salvar("microfone", v);
                  },
                ),

                _tile(
                  Icons.lock,
                  "Autenticação Segura",
                  "Ativa uma camada extra de proteção da conta.",
                  autenticacao,
                      (v) {
                    setState(() => autenticacao = v);
                    salvar("autenticacao", v);
                  },
                ),

                _tile(
                  Icons.analytics,
                  "Relatórios Anônimos",
                  "Ajuda a melhorar o aplicativo enviando dados anônimos.",
                  relatorios,
                      (v) {
                    setState(() => relatorios = v);
                    salvar("relatorios", v);
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: limparDados,
                  icon: const Icon(Icons.delete),
                  label: const Text("Apagar todos os meus dados"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tile(
      IconData icon,
      String title,
      String description,
      bool value,
      Function(bool) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 133, 105),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          secondary: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}