import 'package:flutter/material.dart';

class Denuncias2 extends StatefulWidget {
  const Denuncias2({super.key});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
  // Variável para armazenar o tipo selecionado
  String tipoSelecionado = "";

  final List<String> tiposDenuncia = [
    "Lixo Acumulado",
    "Falta de Coleta",
    "Descarte Irregular",
    "Entulho",
    "Outros"
  ];

  InputDecoration campo(String texto, IconData icon) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icon, color: const Color(0xFF1F5C3A)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removido o bottomNavigationBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD2E1D4), // Cor mais clara para combinar com o app
              Color(0xFFF2F2F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔹 TOPO (AppBar Custom)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1F5C3A)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Nova Denúncia",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F5C3A),
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 TÓPICOS: TIPO DE DENÚNCIA
                      const Text(
                        "Selecione o tipo de denúncia:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tiposDenuncia.map((tipo) {
                          final isSelected = tipoSelecionado == tipo;
                          return ChoiceChip(
                            label: Text(tipo),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                tipoSelecionado = selected ? tipo : "";
                              });
                            },
                            selectedColor: const Color(0xFF59BA15),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25),

                      /// 🔹 ENDEREÇO
                      const Text(
                        "Endereço da Ocorrência",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      TextField(decoration: campo("CEP", Icons.location_on)),
                      const SizedBox(height: 12),
                      TextField(decoration: campo("Rua", Icons.map)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: TextField(decoration: campo("Número", Icons.pin))),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(decoration: campo("Bairro", Icons.place))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(decoration: campo("Complemento", Icons.apartment)),

                      const SizedBox(height: 25),

                      /// 🔹 DESCRIÇÃO
                      const Text(
                        "Detalhes",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF63866C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          maxLines: 4,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Descreva o que está acontecendo...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 BOTÕES DE MÍDIA
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              label: const Text("Câmera", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF63866C),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.photo, color: Colors.white, size: 20),
                              label: const Text("Galeria", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF63866C),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// 🔹 BOTÃO ENVIAR
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica de envio aqui
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: const Color(0xFF59BA15),
                            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                            elevation: 5,
                          ),
                          child: const Text(
                            "ENVIAR DENÚNCIA",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}