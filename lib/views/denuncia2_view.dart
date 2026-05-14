import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- 1. TELA DE FORMULÁRIO (DENUNCIAS2) ---
class Denuncias2 extends StatefulWidget {
  const Denuncias2({super.key});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD2E1D4),
              Color(0xFFF2F2F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1F5C3A)),
                      onPressed: () => Navigator.pop(context),
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

                      // ESPAÇO PARA ESCRITA (Aparece apenas se selecionar "Outros")
                      if (tipoSelecionado == "Outros")
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextField(
                            decoration: campo("Qual o tipo de denúncia?", Icons.edit_note),
                          ),
                        ),

                      const SizedBox(height: 25),
                      const Text(
                        "Endereço da Ocorrência",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      
                      TextField(
                        decoration: campo("CEP", Icons.location_on),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      
                      const SizedBox(height: 12),
                      TextField(decoration: campo("Rua", Icons.map)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: campo("Número", Icons.pin),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(decoration: campo("Bairro", Icons.place))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(decoration: campo("Complemento", Icons.apartment)),
                      const SizedBox(height: 25),
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
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // VAI PARA A TELA DE SPLASH
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EnvioDenunciaSplash()),
                            );
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

// --- 2. TELA DE SPLASH (SIMULA O ENVIO) ---
class EnvioDenunciaSplash extends StatefulWidget {
  const EnvioDenunciaSplash({super.key});

  @override
  State<EnvioDenunciaSplash> createState() => _EnvioDenunciaSplashState();
}

class _EnvioDenunciaSplashState extends State<EnvioDenunciaSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmacaoDenunciaView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1F5C3A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text("Enviando sua denúncia...", style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// --- 3. TELA DE CONFIRMAÇÃO (SUCESSO) ---
class ConfirmacaoDenunciaView extends StatelessWidget {
  const ConfirmacaoDenunciaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 100, color: Color(0xFF59BA15)),
              const SizedBox(height: 20),
              const Text(
                "Denúncia Enviada!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sua solicitação foi registrada com sucesso.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5C3A),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("VOLTAR AO INÍCIO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}