import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SobreAppView extends StatefulWidget {
  const SobreAppView({super.key});

  @override
  State<SobreAppView> createState() => _SobreAppViewState();
}

class _SobreAppViewState extends State<SobreAppView> {
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

  Future<void> carregarConfiguracoes() async {
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
    // --- TEMAS ADAPTATIVOS ---
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
          title: const Text("SOBRE O APP",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 2)),
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
              padding: const EdgeInsets.only(bottom: 35, top: 10),
              decoration: BoxDecoration(
                color: corTema,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.help_outline,
                        size: 45, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Meu App v1.0.0",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Transformando sua produtividade",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                ],
              ),
            ),

            // --- LISTA DE INFORMAÇÕES ---
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                children: [
                  _buildSectionTitle("Informações Legais"),
                  _buildInfoCard(Icons.description_rounded, "Termos de Uso",
                      "Leia as nossas condições de serviço.", corTema, () {
                    vibrar();
                  }),
                  _buildInfoCard(Icons.privacy_tip_rounded, "Política de Privacidade",
                      "Como cuidamos dos seus dados.", corTema, () {
                    vibrar();
                  }),
                  _buildInfoCard(Icons.code_rounded, "Licenças",
                      "Créditos de bibliotecas open source.", corTema, () {
                    vibrar();
                    showLicensePage(context: context);
                  }),
                  
                  const SizedBox(height: 30),
                  
                  // Rodapé
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, color: altoContraste ? Colors.black : Colors.red.shade300, size: 20),
                        const SizedBox(height: 8),
                        Text(
                          "Desenvolvido pela Equipe",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                        Text(
                          "2026 © Todos os direitos reservados",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade600,
            letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle, Color corTema, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: altoContraste ? Colors.black : corTema),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: altoContraste ? Colors.black : const Color(0xFF2D312E)),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}