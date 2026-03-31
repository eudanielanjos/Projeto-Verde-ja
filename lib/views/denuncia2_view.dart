import 'package:flutter/material.dart';

class Denuncias2 extends StatefulWidget {
  const Denuncias2({super.key});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
  int _selectedIndex = 0;

  InputDecoration campo(String texto, IconData icon) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
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

              /// 🔹 TOPO
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF295822)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Endereço da Denúncia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(decoration: campo("CEP", Icons.location_on)),
                      const SizedBox(height: 12),

                      TextField(decoration: campo("Rua", Icons.map)),
                      const SizedBox(height: 12),

                      TextField(decoration: campo("Número", Icons.pin)),
                      const SizedBox(height: 12),

                      TextField(decoration: campo("Complemento", Icons.apartment)),
                      const SizedBox(height: 12),

                      TextField(decoration: campo("Bairro", Icons.place)),

                      const SizedBox(height: 20),

                      /// 🔹 DESCRIÇÃO
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF63866C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          maxLines: 4,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Descreva o problema...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 BOTÃO CAMERA
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.white),
                        label: const Text(
                          "Nova foto ou vídeo",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: const Color(0xFF63866C),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 GALERIA
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.photo, color: Colors.white),
                        label: const Text(
                          "Adicionar da Galeria",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: const Color(0xFF63866C),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// 🔹 ENVIAR
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xFF59BA15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 14),
                          ),
                          child: const Text(
                            "ENVIAR DENÚNCIA",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔻 BARRA INFERIOR
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(
              color: Colors.white70,
            );
          }),
        ),
        child: NavigationBar(
          height: 76,
          backgroundColor: const Color(0xFF1F5C3A),
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.white24,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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