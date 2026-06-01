import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class PrivacidadeView extends StatefulWidget {
  const PrivacidadeView({super.key});

  @override
  State<PrivacidadeView> createState() => _PrivacidadeViewState();
}

class _PrivacidadeViewState extends State<PrivacidadeView> {
  // --- ESTADOS DE PERMISSÕES ---
  bool localizacao = false;
  bool camera = false;
  bool microfone = false;
  bool historico = false;
  bool relatorios = false;
  bool autenticacao = false;

  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  // Carrega as permissões e as configurações de acessibilidade
  Future<void> carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { 
      // Permissões
      localizacao = prefs.getBool('localizacao') ?? false;
      camera = prefs.getBool('camera') ?? false;
      microfone = prefs.getBool('microfone') ?? false;
      historico = prefs.getBool('historico') ?? false;
      relatorios = prefs.getBool('relatorios') ?? false;
      autenticacao = prefs.getBool('autenticacao') ?? false;

      // Acessibilidade
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      escalaFonte = fonteGrande ? 1.25 : 1.0;
    });
  }

  // Lógica de vibração sutil
  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  Future<void> salvar(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(chave, valor);
  }

  Future<void> limparDados() async {
    vibrar();
    final prefs = await SharedPreferences.getInstance();
    
    // Preserva as configurações de acessibilidade antes de limpar o resto
    final dalt = prefs.getBool('daltonismo') ?? false;
    final font = prefs.getBool('fonteGrande') ?? false;
    final alto = prefs.getBool('altoContraste') ?? false;
    final vibra = prefs.getBool('vibracao') ?? false;
    final zoom = prefs.getBool('zoomInterface') ?? false;

    await prefs.clear();

    // Restaura as acessibilidades essenciais
    await prefs.setBool('daltonismo', dalt);
    await prefs.setBool('fonteGrande', font);
    await prefs.setBool('altoContraste', alto);
    await prefs.setBool('vibracao', vibra);
    await prefs.setBool('zoomInterface', zoom);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Todos os dados de uso foram apagados.", style: TextStyle(fontWeight: FontWeight.bold)), 
          backgroundColor: Colors.redAccent
        ),
      );
    }
    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    // --- TEMAS ADAPTATIVOS DE COR E FUNDO ---
    Color corTema;
    Color corFundoTela;

    if (altoContraste) {
      corTema = Colors.black;
      corFundoTela = Colors.white;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64); // Azul acinzetado adaptado
      corFundoTela = const Color(0xFFECEFF1);
    } else {
      corTema = const Color(0xFF1F5C3A); // Verde padrão
      corFundoTela = const Color(0xFFF8FAF9);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: corFundoTela,
        appBar: AppBar(
          title: const Text("PRIVACIDADE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
          centerTitle: true,
          backgroundColor: corTema,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () {
              vibrar();
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // --- HEADER CURVADO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: BoxDecoration(
                color: corTema,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
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
                  _buildToggleCard(Icons.location_on_rounded, "Localização", "Uso do GPS no app.", localizacao, corTema, (v) {
                    vibrar();
                    setState(() => localizacao = v);
                    salvar("localizacao", v);
                  }),
                  _buildToggleCard(Icons.camera_alt_rounded, "Câmera", "Captura de fotos para registros.", camera, corTema, (v) {
                    vibrar();
                    setState(() => camera = v);
                    salvar("camera", v);
                  }),
                  _buildToggleCard(Icons.mic_rounded, "Microfone", "Gravação de áudio integrada.", microfone, corTema, (v) {
                    vibrar();
                    setState(() => microfone = v);
                    salvar("microfone", v);
                  }),

                  _buildSectionTitle("Dados e Segurança"),
                  _buildToggleCard(Icons.history_rounded, "Histórico", "Salvar atividades recentes.", historico, corTema, (v) {
                    vibrar();
                    setState(() => historico = v);
                    salvar("historico", v);
                  }),
                  _buildToggleCard(Icons.fingerprint_rounded, "Autenticação", "Camada extra de proteção.", autenticacao, corTema, (v) {
                    vibrar();
                    setState(() => autenticacao = v);
                    salvar("autenticacao", v);
                  }),

                  const SizedBox(height: 20),
                  
                  // Botão de Limpar Dados
                  _buildDangerButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 10),
      child: Text(
        title.toUpperCase(), 
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1.5)
      ),
    );
  }

  Widget _buildToggleCard(IconData icon, String title, String subtitle, bool value, Color corTema, Function(bool) onChanged) {
    // Ajuste fino para contraste do contorno do Card
    Border? cardBorder;
    if (altoContraste) {
      cardBorder = Border.all(color: Colors.black, width: 2);
    } else if (value) {
      cardBorder = Border.all(color: corTema, width: 2);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: cardBorder,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: altoContraste ? Colors.black : corTema,
        activeTrackColor: altoContraste ? Colors.grey.shade400 : corTema.withOpacity(0.3),
        secondary: Container(
          height: 45, width: 45,
          decoration: BoxDecoration(
            color: value 
                ? (altoContraste ? Colors.grey.shade200 : corTema.withOpacity(0.12)) 
                : const Color(0xFFF1F5F2), 
            borderRadius: BorderRadius.circular(12)
          ),
          child: Icon(icon, color: value ? (altoContraste ? Colors.black : corTema) : Colors.grey),
        ),
        title: Text(
          title, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: altoContraste ? Colors.black : const Color(0xFF2D312E))
        ),
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
          border: Border.all(color: altoContraste ? Colors.red.shade900 : Colors.red.shade100, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red.shade700),
            const SizedBox(width: 10),
            Text(
              "Apagar todos os dados", 
              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}