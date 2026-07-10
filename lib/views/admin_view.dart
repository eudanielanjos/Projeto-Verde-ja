import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AdminMenuView extends StatefulWidget {
  const AdminMenuView({super.key});

  @override
  State<AdminMenuView> createState() => _AdminMenuViewState();
}

class _AdminMenuViewState extends State<AdminMenuView> {
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

  // --- LÓGICA DE ACESSIBILIDADE ---
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
    // Definição dinâmica das cores baseada na acessibilidade
    Color greenDark;
    Color greenPrimary;
    const Color softWhite = Color(0xFFF8FAFB);

    if (altoContraste) {
      greenDark = Colors.black;
      greenPrimary = Colors.black87;
    } else if (daltonismo) {
      greenDark = const Color(0xFF37474F);
      greenPrimary = const Color(0xFF455A64);
    } else {
      greenDark = const Color(0xFF133621);
      greenPrimary = const Color(0xFF1B4D2E);
    }

    // MediaQuery aplicando o multiplicador de fonte da acessibilidade
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [greenDark, greenPrimary],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/logo2.png', height: 90),
                
                const SizedBox(height: 20),
                const Text(
                  'Olá, Administrador',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: const BoxDecoration(
                      color: softWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 🔹 GRID DE FUNCIONALIDADES
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.1,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildGridItem(context, 'Gestão de\ncoletas', Icons.recycling, '/gestaoColetasAdmin', greenPrimary),
                              _buildGridItem(context, 'Área\neducativa', Icons.school, '/educacaoAdmin', greenPrimary),
                              _buildGridItem(context, 'Fale\nconosco', Icons.chat_bubble, '/home_visitante', greenPrimary),
                              _buildGridItem(context, 'Histórico de\ndenúncias', Icons.history, '/historicoAdmin', greenPrimary),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 🔹 BOTÃO VOLTAR PERSONALIZADO
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              vibrar(); // Feedback tátil ao voltar
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: greenPrimary, // Cor dinâmica aplicada aqui
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Voltar para o Início',
                                    style: TextStyle(
                                      color: Colors.white, 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
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

  // 🔹 Widget para os botões do Grid modificado para aceitar cor primária dinâmica
  Widget _buildGridItem(BuildContext context, String title, IconData icon, String route, Color activeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            vibrar(); // Feedback tátil ao selecionar funcionalidade
            Navigator.pushNamed(context, route);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: activeColor, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}