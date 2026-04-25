import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import necessário
import 'package:google_sign_in/google_sign_in.dart'; // Import necessário
import 'denuncia_view.dart';
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'coleta_view.dart';

class TelaInicialView extends StatefulWidget {
  const TelaInicialView({super.key});

  @override
  State<TelaInicialView> createState() => _TelaInicialViewState();
}

class _TelaInicialViewState extends State<TelaInicialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            // Header do Menu (Mantido original)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 25),
              decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Itens do Menu (Mantido original)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildMenuCard(
                    icon: Icons.home,
                    title: "Início",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuCard(
                    icon: Icons.calendar_month,
                    title: "Coleta Regular",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.school,
                    title: "Educação",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.history_edu,
                    title: "Histórico de Denúncias",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.settings,
                    title: "Configurações",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage()));
                    },
                  ),
                ],
              ),
            ),

            // 🔥 BOTÃO SAIR DA CONTA COM LIMPEZA DE CACHE E LOGOUT
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  // 1. Limpa o cache de imagens da memória do Flutter
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();

                  // 2. Faz o logout no Firebase e no Google
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();

                  // 3. Redireciona para a HomeView e remove todas as telas anteriores da pilha
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                      (route) => false,
                    );
                  }
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Restante do body (Mantido original)
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(120, 159, 130, 1), Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Builder(
                builder: (context) => Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 30),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
              Center(child: Image.asset('assets/images/logo3.png', width: 200)),
              const SizedBox(height: 15),
              const Center(
                child: Text("Bem-vindo ao VerdeJá 🌿",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Explore as funcionalidades do aplicativo, informe-se e faça parte dessa mudança!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              _buildMainCard(
                imagePath: 'assets/images/lixo.png',
                title: 'Denuncie Agora',
                subtitle: 'Denuncie descarte ilegal',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalDenunciaPage()));
                },
              ),
              const SizedBox(height: 15),
              _buildMainCard(
                imagePath: 'assets/images/icon1.png',
                title: 'Coleta Regular',
                subtitle: 'Horários e Dias no Bairro',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                },
              ),
              const SizedBox(height: 15),
              _buildMainCard(
                imagePath: 'assets/images/icon2.png',
                title: 'Coleta Seletiva',
                subtitle: 'Confira os dias disponíveis',
                icon: Icons.calendar_month,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets Auxiliares (Mantidos originais)
  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
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
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard({required String imagePath, required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      height: 110,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Card(
          color: const Color.fromRGBO(137, 186, 21, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(imagePath, width: 45),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(subtitle, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                ),
                Icon(icon, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}