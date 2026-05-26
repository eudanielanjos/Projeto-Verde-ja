import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'denuncia2_view.dart';

class LocalDenunciaPage extends StatefulWidget {
  const LocalDenunciaPage({super.key});

  @override
  State<LocalDenunciaPage> createState() => _LocalDenunciaPageState();
}

class _LocalDenunciaPageState extends State<LocalDenunciaPage> {
  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    carregarAcessibilidade();
  }

  Future<void> carregarAcessibilidade() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    // --- DEFINIÇÃO DE CORES DINÂMICAS ---
    Color corTextoDestaque;
    Color corBotaoPrimario;
    Color corBotaoSecundario;

    if (altoContraste) {
      corTextoDestaque = Colors.black;
      corBotaoPrimario = Colors.black;
      corBotaoSecundario = const Color(0xFF424242);
    } else if (daltonismo) {
      corTextoDestaque = const Color(0xFF455A64);
      corBotaoPrimario = const Color(0xFF37474F);
      corBotaoSecundario = const Color(0xFF546E7A);
    } else {
      corTextoDestaque = const Color(0xFF1F5C3A);
      corBotaoPrimario = const Color(0xFF59BA15);
      corBotaoSecundario = const Color(0xFF63866C);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: corTextoDestaque),
            onPressed: () {
              vibrar();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                altoContraste ? Colors.white : const Color(0xFFD2E1D4),
                const Color(0xFFF2F2F2),
                const Color(0xFFF2F2F2),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                /// 🔹 TÍTULO EM DESTAQUE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Defina o local de denúncia:",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: corTextoDestaque,
                      letterSpacing: -0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 50),

                /// 🔹 BOTÕES CENTRALIZADOS
                _buildCenterButton(
                  context: context,
                  icon: Icons.my_location_rounded,
                  text: "Usar Minha Localização",
                  corFundo: corBotaoPrimario,
                  onPressed: () {
                    vibrar();
                    // Lógica de GPS
                  },
                ),

                const SizedBox(height: 20),

                _buildCenterButton(
                  context: context,
                  icon: Icons.keyboard_rounded,
                  text: "Digitar endereço",
                  corFundo: corBotaoSecundario,
                  onPressed: () {
                    vibrar();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Denuncias2()),
                    ).then((_) => carregarAcessibilidade());
                  },
                ),

                const Spacer(flex: 3),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 WIDGET DE BOTÃO OTIMIZADO
  Widget _buildCenterButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color corFundo,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}