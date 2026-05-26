import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

// --- 1. TELA DE FORMULÁRIO (DENUNCIAS2) ---
class Denuncias2 extends StatefulWidget {
  const Denuncias2({super.key});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
  String tipoSelecionado = "";
  File? _imagemDenuncia;
  final ImagePicker _picker = ImagePicker();

  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  double escalaFonte = 1.0;

  final List<String> tiposDenuncia = [
    "Lixo Acumulado",
    "Falta de Coleta",
    "Descarte Irregular",
    "Entulho",
    "Outros"
  ];

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

  Future<void> _escolherImagem(ImageSource source) async {
    vibrar();
    try {
      final XFile? imagemSelecionada = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );

      if (imagemSelecionada != null) {
        setState(() {
          _imagemDenuncia = File(imagemSelecionada.path);
        });
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
    }
  }

  InputDecoration campo(String texto, IconData icon, Color corIcone) {
    return InputDecoration(
      labelText: texto,
      labelStyle: TextStyle(color: altoContraste ? Colors.black : Colors.black54),
      prefixIcon: Icon(icon, color: corIcone),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: corIcone, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- CORES DINÂMICAS ---
    Color corPrincipal;
    Color corSecundaria;
    Color corSucesso;

    if (altoContraste) {
      corPrincipal = Colors.black;
      corSecundaria = const Color(0xFF424242);
      corSucesso = Colors.black;
    } else if (daltonismo) {
      corPrincipal = const Color(0xFF455A64);
      corSecundaria = const Color(0xFF546E7A);
      corSucesso = const Color(0xFF37474F);
    } else {
      corPrincipal = const Color(0xFF1F5C3A);
      corSecundaria = const Color(0xFF63866C);
      corSucesso = const Color(0xFF59BA15);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                altoContraste ? Colors.white : const Color(0xFFD2E1D4),
                const Color(0xFFF2F2F2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: corPrincipal),
                        onPressed: () {
                          vibrar();
                          Navigator.pop(context);
                        },
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
                                vibrar();
                                setState(() {
                                  tipoSelecionado = selected ? tipo : "";
                                });
                              },
                              selectedColor: corSucesso,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: altoContraste ? const BorderSide(color: Colors.black) : BorderSide.none,
                              ),
                            );
                          }).toList(),
                        ),

                        if (tipoSelecionado == "Outros")
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextField(
                              decoration: campo("Qual o tipo de denúncia?", Icons.edit_note, corPrincipal),
                            ),
                          ),

                        const SizedBox(height: 25),
                        const Text(
                          "Endereço da Ocorrência",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        
                        TextField(
                          decoration: campo("CEP", Icons.location_on, corPrincipal),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        
                        const SizedBox(height: 12),
                        TextField(decoration: campo("Rua", Icons.map, corPrincipal)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: campo("Número", Icons.pin, corPrincipal),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: TextField(decoration: campo("Bairro", Icons.place, corPrincipal))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(decoration: campo("Complemento", Icons.apartment, corPrincipal)),
                        
                        const SizedBox(height: 25),
                        const Text(
                          "Detalhes",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: corSecundaria,
                            borderRadius: BorderRadius.circular(12),
                            border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
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
                                onPressed: () => _escolherImagem(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                label: const Text("Câmera", style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: corSecundaria,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _escolherImagem(ImageSource.gallery),
                                icon: const Icon(Icons.photo, color: Colors.white, size: 20),
                                label: const Text("Galeria", style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: corSecundaria,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_imagemDenuncia != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
                                    image: DecorationImage(
                                      image: FileImage(_imagemDenuncia!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
                                  onPressed: () {
                                    vibrar();
                                    setState(() => _imagemDenuncia = null);
                                  },
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              vibrar();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EnvioDenunciaSplash(
                                  altoContraste: altoContraste, 
                                  corFundo: corPrincipal
                                )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: altoContraste ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
                              ),
                              backgroundColor: corSucesso,
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
      ),
    );
  }
}

// --- 2. TELA DE SPLASH (SIMULA O ENVIO) ---
class EnvioDenunciaSplash extends StatefulWidget {
  final bool altoContraste;
  final Color corFundo;
  const EnvioDenunciaSplash({super.key, required this.altoContraste, required this.corFundo});

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
          MaterialPageRoute(builder: (context) => ConfirmacaoDenunciaView(
            altoContraste: widget.altoContraste,
            corDestaque: widget.corFundo,
          )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.corFundo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              "Enviando sua denúncia...", 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: widget.altoContraste ? FontWeight.bold : FontWeight.normal)
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. TELA DE CONFIRMAÇÃO (SUCESSO) ---
class ConfirmacaoDenunciaView extends StatelessWidget {
  final bool altoContraste;
  final Color corDestaque;
  const ConfirmacaoDenunciaView({super.key, required this.altoContraste, required this.corDestaque});

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
              Icon(
                Icons.check_circle_rounded, 
                size: 100, 
                color: altoContraste ? Colors.black : const Color(0xFF59BA15)
              ),
              const SizedBox(height: 20),
              Text(
                "Denúncia Enviada!",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: altoContraste ? Colors.black : corDestaque
                ),
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
                  backgroundColor: altoContraste ? Colors.black : corDestaque,
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