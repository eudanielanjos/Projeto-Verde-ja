import 'package:flutter/material.dart';
import 'tela_inicial_view.dart';
import 'educacao_view.dart';
import 'perfil_view.dart';
class Denuncias2 extends StatefulWidget {
  const Denuncias2({super.key});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
  int _selectedIndex = 0;
void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaInicialView(),
        ),
      );
    }

        if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EducacaoView(),
        ),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PerfilPage(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E7F6B),
              Color(0xFFF2F2F2),
              Color(0xFFF2F2F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // Topo
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF295822)),
                      onPressed: () {
                        Navigator.pop(context); // 🔹 Volta para LocalDenunciaPage
                      },
                    ),
                    const Icon(Icons.settings, color: Color(0xFF295822)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Endereço:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const TextField(decoration: InputDecoration(labelText: "Cep")),
                      const TextField(decoration: InputDecoration(labelText: "Rua")),
                      const TextField(decoration: InputDecoration(labelText: "Número")),
                      const TextField(decoration: InputDecoration(labelText: "Complemento")),
                      const TextField(decoration: InputDecoration(labelText: "Bairro")),

                      const SizedBox(height: 20),

                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF63866C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Descrição",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text("Nova foto ou vídeo", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF63866C),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.photo, color: Colors.white),
                        label: const Text("Adicionar da Galeria", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF63866C),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor:  const Color(0xFF59BA15),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                          ),
                          child: const Text("enviar", style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔻 Barra inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
       child: NavigationBar(
          height: 76,
          backgroundColor: const Color(0xFF1F5C3A),
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.white24,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.place_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.place, color: Colors.white),
              label: 'Coleta',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.school, color: Colors.white),
              label: 'Educação',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}