import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AcessibilidadeView extends StatefulWidget {
  const AcessibilidadeView({super.key});

  @override
  State<AcessibilidadeView> createState() => _AcessibilidadeViewState();
}

class _AcessibilidadeViewState extends State<AcessibilidadeView> {
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  bool zoomInterface = false;

  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      zoomInterface = prefs.getBool('zoomInterface') ?? false;
      escalaFonte = fonteGrande ? 1.25 : 1.0;
    });
  }

  Future salvar(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(chave, valor);
  }

  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lógica de cores baseada nas configurações
    Color corPrincipal;

    if (altoContraste) {
      corPrincipal = Colors.black;
    } else if (daltonismo) {
      corPrincipal = const Color(0xFF455A64); // Azul acinzentado para daltonismo
    } else {
      corPrincipal = const Color.fromRGBO(120, 159, 130, 1); // Seu verde padrão
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [corPrincipal, Colors.white],
              stops: const [0.0, 0.25],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // --- BOTÃO VOLTAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                      onPressed: () {
                        vibrar();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                // --- CABEÇALHO ---
                const Icon(Icons.accessibility_new_rounded, size: 50, color: Color.fromARGB(255, 0, 0, 0)),
                const SizedBox(height: 10),
                Text(
                  "ACESSIBILIDADE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1.2,

                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: Text(
                    "Ajuste a interface para sua melhor comodidade visual e tátil.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),

                // --- PAINEL DE OPÇÕES ---
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          _buildSectionTitle("Visual"),
                          _tile(
                            Icons.remove_red_eye_outlined,
                            "Modo Daltonismo",
                            "Paleta de cores otimizada.",
                            daltonismo,
                            (v) {
                              vibrar();
                              setState(() => daltonismo = v);
                              salvar("daltonismo", v);
                            },
                          ),
                          _tile(
                            Icons.format_size_rounded,
                            "Fonte Ampliada",
                            "Aumenta o tamanho dos textos.",
                            fonteGrande,
                            (v) {
                              vibrar();
                              setState(() {
                                fonteGrande = v;
                                escalaFonte = v ? 1.25 : 1.0;
                              });
                              salvar("fonteGrande", v);
                            },
                          ),
                          _tile(
                            Icons.brightness_medium_outlined,
                            "Alto Contraste",
                            "Melhora a definição de bordas e textos.",
                            altoContraste,
                            (v) {
                              vibrar();
                              setState(() => altoContraste = v);
                              salvar("altoContraste", v);
                            },
                          ),
                          
                          _buildSectionTitle("Interação"),
                          _tile(
                            Icons.vibration_rounded,
                            "Resposta Tátil",
                            "Vibrar ao tocar em botões.",
                            vibracao,
                            (v) {
                              setState(() => vibracao = v);
                              salvar("vibracao", v);
                              if (v) vibrar();
                            },
                          ),
                          _tile(
                            Icons.zoom_in_rounded,
                            "Zoom da Interface",
                            "Amplia elementos interativos.",
                            zoomInterface,
                            (v) {
                              vibrar();
                              setState(() => zoomInterface = v);
                              salvar("zoomInterface", v);
                            },
                          ),
                          const SizedBox(height: 40),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 15),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String description, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF1F5C3A),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1F5C3A), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1F5C3A),
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}