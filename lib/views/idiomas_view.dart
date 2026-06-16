import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../l10n/app_localizations.dart'; 
import '../main.dart'; 

class IdiomasView extends StatefulWidget {
  const IdiomasView({super.key});

  @override
  State<IdiomasView> createState() => _IdiomasViewState();
}

class _IdiomasViewState extends State<IdiomasView> {
  String idiomaSelecionado = "Português";

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

  Future<void> carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; 
    
    setState(() {
      idiomaSelecionado = prefs.getString('idiomaSelecionado') ?? "Português";
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      escalaFonte = fonteGrande ? 1.25 : 1.0;
    });
  }

  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  Future<void> salvarIdioma(String idioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idiomaSelecionado', idioma);

    Locale novoLocale;
    switch (idioma) {
      case "English":
        novoLocale = const Locale('en');
        break;
      case "Español":
        novoLocale = const Locale('es');
        break;
      case "Français":
        novoLocale = const Locale('fr');
        break;
      default:
        novoLocale = const Locale('pt');
    }

    if (mounted) {
      MyApp.setLocale(context, novoLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Color corTema;
    Color corFundoTela;

    if (altoContraste) {
      corTema = Colors.black;
      corFundoTela = Colors.white;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64); 
      corFundoTela = const Color(0xFFECEFF1);
    } else {
      corTema = const Color(0xFF1F5C3A); 
      corFundoTela = const Color(0xFFF8FAF9);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: corFundoTela,
        appBar: AppBar(
          title: Text(
            t.idiomasTitle, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: BoxDecoration(
                color: corTema,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.translate_rounded, size: 50, color: Colors.white70),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      t.idiomasSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                  _buildIdioma("Português", "🇧🇷", t.portugues, corTema),
                  _buildIdioma("English", "🇺🇸", t.english, corTema),
                  _buildIdioma("Español", "🇪🇸", t.espanol, corTema),
                  _buildIdioma("Français", "🇫🇷", t.francais, corTema),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdioma(String idioma, String bandeira, String subtitulo, Color corTema) {
    bool selecionado = idiomaSelecionado == idioma;

    Border? cardBorder;
    if (altoContraste) {
      cardBorder = Border.all(color: Colors.black, width: 2);
    } else if (selecionado) {
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
          BoxShadow(
            color: selecionado ? corTema.withOpacity(0.1) : Colors.black.withOpacity(0.04), 
            blurRadius: 12, 
            offset: const Offset(0, 6)
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            vibrar();
            if (mounted) {
              setState(() => idiomaSelecionado = idioma);
            }
            salvarIdioma(idioma);
          },
          borderRadius: BorderRadius.circular(22), 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(
                    color: selecionado 
                        ? (altoContraste ? Colors.grey.shade200 : corTema.withOpacity(0.12)) 
                        : const Color(0xFFF1F5F2), 
                    borderRadius: BorderRadius.circular(15)
                  ),
                  alignment: Alignment.center,
                  child: Text(bandeira, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        idioma, 
                        style: TextStyle(
                          color: selecionado ? (altoContraste ? Colors.black : corTema) : const Color(0xFF2D312E), 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(subtitulo, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(
                  selecionado ? Icons.check_circle_rounded : Icons.circle_outlined, 
                  color: selecionado ? (altoContraste ? Colors.black : corTema) : Colors.grey.shade300, 
                  size: 28
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}