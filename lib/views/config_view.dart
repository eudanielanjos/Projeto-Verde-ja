import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

// Suas importações existentes
import 'acessibilidade_view.dart'; 
import 'privacidade_view.dart';
import 'idiomas_view.dart';
import 'home_view.dart';
import 'tela_inicial_view.dart';
import 'coleta_view.dart';
import 'educacao_view.dart';
import 'perfil_view.dart';
import 'historico_denuncias_view.dart';
import 'notificacoes_view.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  bool zoomInterface = false;
  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    carregarAcessibilidade();
  }

  // Carrega as configurações guardadas no dispositivo
  Future<void> carregarAcessibilidade() async {
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

  // Lógica de vibração sutil para feedback do usuário
  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  // Gerencia a navegação atualizando o estado assim que o usuário retornar à tela
  void navegarParaTela(Widget tela, {bool replacement = false}) async {
    vibrar();
    if (replacement) {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => tela));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
    }
    carregarAcessibilidade(); // Força a atualização visual caso mudado na tela de Acessibilidade
  }

  // Função centralizada para exibir a mensagem "Em breve"
  void _mostrarMensagemEmBreve(BuildContext context) {
    vibrar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Funcionalidade em breve!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F5C3A),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
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
      corTema = const Color(0xFF455A64); // Azul acinzentado
      corFundoTela = const Color(0xFFECEFF1);
    } else {
      corTema = const Color(0xFF1F5C3A); // Verde padrão
      corFundoTela = const Color(0xFFF8FAF9);
    }

    // Adaptando o espaçamento da grade com o Zoom de Interface
    double proporcaoAspectoGrid = zoomInterface ? 0.85 : 1.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: corFundoTela,
        
        // --- MENU LATERAL (DRAWER) ---
        endDrawer: _buildMenuDrawer(context, corTema),

        appBar: AppBar(
          title: const Text("CONFIGURAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
          centerTitle: true,
          backgroundColor: corTema,
          elevation: 0,
          automaticallyImplyLeading: false, 
          actions: [
            Builder(builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                vibrar();
                Scaffold.of(context).openEndDrawer();
              },
            )),
          ],
        ),

        body: Column(
          children: [
            // Header Curvado adaptável
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 35, top: 10),
              decoration: BoxDecoration(
                color: corTema,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.settings_suggest_rounded, size: 55, color: Colors.white70),
                  SizedBox(height: 15),
                  Text("Personalize sua experiência", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),

            // --- GRADE DE BOTÕES (GRID) ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: proporcaoAspectoGrid,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildGridButton(
                    icon: Icons.lock_outline, 
                    label: "Privacidade", 
                    corTema: corTema,
                    onTap: () => navegarParaTela(const PrivacidadeView())
                  ),
                  _buildGridButton(
                    icon: Icons.accessibility_new, 
                    label: "Acessibilidade", 
                    corTema: corTema,
                    onTap: () => navegarParaTela(const AcessibilidadeView())
                  ),
                  _buildGridButton(
                    icon: Icons.translate, 
                    label: "Idiomas", 
                    corTema: corTema,
                    onTap: () => navegarParaTela(const IdiomasView())
                  ),
                  _buildGridButton(
                    icon: Icons.notifications_none, 
                    label: "Notificações", 
                    corTema: corTema,
                    onTap: () => navegarParaTela(const NotificacoesView())
                  ), 
                  _buildGridButton(
                    icon: Icons.dark_mode_outlined, 
                    label: "Tema", 
                    corTema: corTema,
                    onTap: () => _mostrarMensagemEmBreve(context)
                  ),
                  _buildGridButton(
                    icon: Icons.help_outline, 
                    label: "Suporte", 
                    corTema: corTema,
                    onTap: () => _mostrarMensagemEmBreve(context)
                  ),
                  _buildGridButton(
                    icon: Icons.info_outline, 
                    label: "Sobre o App", 
                    corTema: corTema,
                    onTap: () => _mostrarMensagemEmBreve(context)
                  ),
                  _buildGridButton(
                    icon: Icons.delete_forever_outlined, 
                    label: "Excluir Conta", 
                    corTema: corTema,
                    onTap: () {
                      vibrar();
                      // Implementação futura de exclusão de conta
                    }, 
                    color: Colors.red.shade50
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BOTÃO DA GRADE (GRID) ---
  Widget _buildGridButton({required IconData icon, required String label, required Color corTema, required VoidCallback onTap, Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color != null ? Colors.white.withOpacity(0.5) : const Color(0xFFF1F5F2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: corTema, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D312E)),
            ),
          ],
        ),
      ),
    );
  }

  // --- DRAWER (MENU LATERAL) ---
  Widget _buildMenuDrawer(BuildContext context, Color corTema) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: BoxDecoration(color: corTema),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Olá, Usuario", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildMenuCard(icon: Icons.home, title: "Início", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const TelaInicialView(), replacement: true);
                }),
                _buildMenuCard(icon: Icons.calendar_month, title: "Coleta Regular", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const ColetaView());
                }),
                _buildMenuCard(icon: Icons.school, title: "Educação", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const EducacaoView());
                }),
                _buildMenuCard(icon: Icons.history_edu, title: "Histórico de Denúncias", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const HistoricoDenunciasView());
                }),
                _buildMenuCard(icon: Icons.person, title: "Perfil", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const PerfilPage());
                }),
                _buildMenuCard(icon: Icons.settings, title: "Configurações", corTema: corTema, onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          _buildSairButton(context),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corTema, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: corTema),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                Icon(Icons.arrow_forward_ios, color: corTema, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () async {
          vibrar();
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
          }
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 10),
              Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}