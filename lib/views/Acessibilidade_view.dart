import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AcessibilidadeView extends StatefulWidget {
  const AcessibilidadeView({super.key});

  @override
  State<AcessibilidadeView> createState() => _AcessibilidadeViewState();
}

class _AcessibilidadeViewState extends State<AcessibilidadeView> {
  // --- ESTADOS ---
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

  // --- LÓGICA ---
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
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definição da cor do Header baseada nos modos de acessibilidade
    Color corTema;
    if (altoContraste) {
      corTema = Colors.black;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64);
    } else {
      corTema = const Color(0xFF1F5C3A);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          title: const Text(
            "ACESSIBILIDADE",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.accessibility_new_rounded, size: 50, color: Colors.white70),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Ajuste a interface para sua melhor comodidade visual e tátil.",
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
                  _buildSectionTitle("Visual"),
                  _buildToggleCard(
                    Icons.remove_red_eye_outlined,
                    "Modo Daltonismo",
                    "Paleta de cores otimizada.",
                    daltonismo,
                    (v) {
                      vibrar();
                      setState(() => daltonismo = v);
                      salvar("daltonismo", v);
                    },
                    corTema,
                  ),
                  _buildToggleCard(
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
                    corTema,
                  ),
                  _buildToggleCard(
                    Icons.brightness_medium_outlined,
                    "Alto Contraste",
                    "Melhora a definição de bordas.",
                    altoContraste,
                    (v) {
                      vibrar();
                      setState(() => altoContraste = v);
                      salvar("altoContraste", v);
                    },
                    corTema,
                  ),

                  _buildSectionTitle("Interação"),
                  _buildToggleCard(
                    Icons.vibration_rounded,
                    "Resposta Tátil",
                    "Vibrar ao tocar em botões.",
                    vibracao,
                    (v) {
                      setState(() => vibracao = v);
                      salvar("vibracao", v);
                      if (v) vibrar();
                    },
                    corTema,
                  ),
                  _buildToggleCard(
                    Icons.zoom_in_rounded,
                    "Zoom da Interface",
                    "Amplia elementos interativos.",
                    zoomInterface,
                    (v) {
                      vibrar();
                      setState(() => zoomInterface = v);
                      salvar("zoomInterface", v);
                    },
                    corTema,
                  ),
                  const SizedBox(height: 20),
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
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color activeColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: value ? activeColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor,
        activeTrackColor: activeColor.withOpacity(0.3),
        secondary: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: value ? activeColor.withOpacity(0.1) : const Color(0xFFF1F5F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: value ? activeColor : Colors.grey,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}