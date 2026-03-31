import 'package:flutter/material.dart';
import 'tela_inicial_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'educacao_view.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perfil Completo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PerfilPage(),
    );
  }
}

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildMenuDrawer(context),
      body: _buildDashboard(context),
    );
  }

  // MENU LATERAL
  Widget _buildMenuDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Olá, Usuario",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildMenuCard(
                  icon: Icons.home,
                  title: "Início",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TelaInicialView()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.calendar_today,
                  title: "Coleta Regular",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuCard(
                  icon: Icons.school,
                  title: "Educação",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EducacaoView()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.person,
                  title: "Perfil",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuCard(
                  icon: Icons.history,
                  title: "Histórico de Denúncias",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoricoDenunciasView(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.settings,
                  title: "Configurações",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfiguracaoPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                  (route) => false,
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Sair da conta",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DASHBOARD COM PERFIL
  Widget _buildDashboard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromRGBO(64, 118, 78, 1), Colors.white],
          stops: [0.0, 0.5],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                  children: [
                      // Avatar principal
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xFF1F5C3A),
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      // Ícone de edição (estático)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Borda externa branca
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1F5C3A), // Fundo do ícone
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt, // Ou Icons.edit
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Nome e e-mail
                  const Text(
                    'Usuario',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F5C3A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Admin123@email.com',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1F5C3A)),
                  ),
                  const SizedBox(height: 16),
                  // Botão de editar perfil
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 24),
                  // Cards de informações
                  InfoCard(
                    icon: Icons.phone,
                    title: 'Telefone',
                    subtitle: '+55 11 99999-9999',
                    backgroundColor: const Color.fromARGB(255, 88, 133, 105),
                  ),
                  InfoCard(
                    icon: Icons.location_on,
                    title: 'Endereço',
                    subtitle: 'Rua, 123 - São Paulo, SP',
                    backgroundColor: const Color.fromARGB(255, 88, 133, 105),
                    
                  ),
                  InfoCard(
                    icon: Icons.lock,
                    title: 'Senha',
                    subtitle: '********',
                    backgroundColor: const Color.fromARGB(255, 88, 133, 105), // cor diferente para destaque
                  ),
                  const SizedBox(height: 24),
                 
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Menu superior
            Positioned(
              top: 0,
              right: 0,
              child: Builder(
                builder: (context) => IconButton(
                  padding: const EdgeInsets.only(right: 8, top: 8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // CARDS DE MENU LATERAL
  Widget _buildMenuCard(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// WIDGET DE CARD DE INFORMAÇÃO
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor; // nova propriedade

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
     this.backgroundColor = Colors.white, // padrão branco
  });

@override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor, // aplica a cor de fundo
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.white), // ícone branco para contraste
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)), // texto branco
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}