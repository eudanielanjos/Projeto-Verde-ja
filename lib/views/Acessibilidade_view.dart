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

  double escalaFonte = 1;

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
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      zoomInterface = prefs.getBool('zoomInterface') ?? false;

      escalaFonte = fonteGrande ? 1.3 : 1;
    });
  }

  // ===============================
  // SALVAR CONFIGURAÇÕES
  // ===============================

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

    // ===============================
    // PALETAS DE CORES
    // ===============================

    Color corTopo;
    Color corContainer;
    Color corTitulo;

    if (altoContraste) {
      corTopo = Colors.black;
      corContainer = Colors.black87;
      corTitulo = Colors.white;
    }

    else if (daltonismo) {
      corTopo = Colors.blueGrey;
      corContainer = Colors.indigo;
      corTitulo = Colors.blue.shade900;
    }

    else {
      corTopo = const Color(0xFF5E7F6B);
      corContainer = const Color.fromARGB(255, 88, 133, 105);
      corTitulo = const Color(0xFF1F5C3A);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: escalaFonte,
      ),

      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                corTopo,
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
                          vibrar();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "ACESSIBILIDADE",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: corTitulo,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _tile(
                    Icons.remove_red_eye,
                    "Modo Daltonismo",
                    "Troca a paleta de cores do aplicativo para facilitar visualização para pessoas com daltonismo.",
                    daltonismo,
                        (v) {
                      vibrar();
                      setState(() => daltonismo = v);
                      salvar("daltonismo", v);
                    },
                    corContainer,
                  ),

                  _tile(
                    Icons.text_fields,
                    "Fonte Ampliada",
                    "Aumenta o tamanho dos textos para facilitar leitura.",
                    fonteGrande,
                        (v) {
                      vibrar();
                      setState(() {
                        fonteGrande = v;
                        escalaFonte = v ? 1.3 : 1;
                      });
                      salvar("fonteGrande", v);
                    },
                    corContainer,
                  ),

                  _tile(
                    Icons.contrast,
                    "Alto Contraste",
                    "Aumenta contraste das cores para melhor visibilidade.",
                    altoContraste,
                        (v) {
                      vibrar();
                      setState(() => altoContraste = v);
                      salvar("altoContraste", v);
                    },
                    corContainer,
                  ),

                  _tile(
                    Icons.vibration,
                    "Vibração de Feedback",
                    "O telefone vibra ao pressionar botões.",
                    vibracao,
                        (v) {
                      setState(() => vibracao = v);
                      salvar("vibracao", v);
                    },
                    corContainer,
                  ),

                  _tile(
                    Icons.zoom_in,
                    "Zoom da Interface",
                    "Amplia elementos visuais para facilitar leitura.",
                    zoomInterface,
                        (v) {
                      vibrar();
                      setState(() => zoomInterface = v);
                      salvar("zoomInterface", v);
                    },
                    corContainer,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // COMPONENTE SWITCH
  // ===============================

  Widget _tile(
      IconData icon,
      String title,
      String description,
      bool value,
      Function(bool) onChanged,
      Color cor,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: cor,
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