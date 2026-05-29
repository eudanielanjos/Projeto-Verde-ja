import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';    
import 'historico_denuncias_view.dart'; 

class Denuncias2 extends StatefulWidget {
  // Recebe opcionalmente os dados recolhidos via GPS da tela anterior
  final Map<String, String>? dadosIniciaisEndereco;

  const Denuncias2({super.key, this.dadosIniciaisEndereco});

  @override
  State<Denuncias2> createState() => _Denuncias2State();
}

class _Denuncias2State extends State<Denuncias2> {
  String tipoSelecionado = "";
  bool _enviando = false;

  final TextEditingController _outroTipoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _detalhesController = TextEditingController();

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
    // Se dados vieram do GPS, preenche os textfields automaticamente ao inicializar a tela
    if (widget.dadosIniciaisEndereco != null) {
      _cepController.text = widget.dadosIniciaisEndereco!['cep'] ?? "";
      _ruaController.text = widget.dadosIniciaisEndereco!['rua'] ?? "";
      _bairroController.text = widget.dadosIniciaisEndereco!['bairro'] ?? "";
      
      String numCapturado = widget.dadosIniciaisEndereco!['numero'] ?? "";
      if (RegExp(r'^[0-9]+$').hasMatch(numCapturado)) {
         _numeroController.text = numCapturado;
      }
    }
  }

  Future<void> _submeterDenuncia() async {
    if (tipoSelecionado.isEmpty) {
      _mostrarAlerta("Por favor, selecione um tipo de denúncia.");
      return;
    }
    if (_cepController.text.isEmpty || _ruaController.text.isEmpty || _bairroController.text.isEmpty) {
      _mostrarAlerta("Por favor, informe o endereço da ocorrência (CEP, Rua e Bairro são obrigatórios).");
      return;
    }

    setState(() => _enviando = true);

    try {
      final User? usuarioAtual = FirebaseAuth.instance.currentUser;
      final String usuarioId = usuarioAtual?.uid ?? "anonimo";
      final String usuarioEmail = usuarioAtual?.email ?? "sem_email";

      String categoriaFinal = tipoSelecionado;
      if (tipoSelecionado == "Outros" && _outroTipoController.text.isNotEmpty) {
        categoriaFinal = _outroTipoController.text.trim();
      }

      // CORREÇÃO: Alterado de FieldValue.serverTimestamp() para Timestamp.now()
      // Isso evita o valor nulo temporário local que quebrava o orderBy do Histórico.
      await FirebaseFirestore.instance.collection('denuncias').add({
        'usuarioId': usuarioId,
        'usuarioEmail': usuarioEmail,
        'tipo': categoriaFinal,
        'endereco': {
          'cep': _cepController.text.trim(),
          'rua': _ruaController.text.trim(),
          'numero': _numeroController.text.trim(),
          'bairro': _bairroController.text.trim(),
          'complemento': _complementoController.text.trim(),
        },
        'detalhes': _detalhesController.text.trim(),
        'status': 'Pendente',
        'criadoEm': Timestamp.now(), 
      });

      if (!mounted) return;

      // Avança para a Splash Screen de envio
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EnvioDenunciaSplash()),
      );

    } catch (e) {
      _mostrarAlerta("Falha ao salvar os dados: $e");
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
    );
  }

  InputDecoration campo(String texto, IconData icon) {
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
  void dispose() {
    _outroTipoController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _complementoController.dispose();
    _detalhesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD2E1D4), Color(0xFFF2F2F2)],
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F5C3A)),
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
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: corPrincipal),
                        onPressed: () {
                          vibrar();
                          Navigator.pop(context);
                        },
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          );
                        }).toList(),
                      ),
                      if (tipoSelecionado == "Outros")
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextField(
                            controller: _outroTipoController,
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
                        controller: _cepController,
                        decoration: campo("CEP", Icons.location_on),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _ruaController,
                        decoration: campo("Rua", Icons.map),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _numeroController,
                              decoration: campo("Número", Icons.pin),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _bairroController,
                              decoration: campo("Bairro", Icons.place),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _complementoController,
                        decoration: campo("Complemento", Icons.apartment),
                      ),
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
                        child: TextField(
                          controller: _detalhesController,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Descreva o que está acontecendo...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
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
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: _enviando
                            ? const CircularProgressIndicator(color: Color(0xFF59BA15))
                            : ElevatedButton(
                                onPressed: _submeterDenuncia,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    Future.delayed(const Duration(milliseconds: 2500), () {
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
      backgroundColor: const Color(0xFF1F5C3A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
            const SizedBox(height: 30),
            Text(
              "Enviando Denúncia...",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmacaoDenunciaView extends StatelessWidget {
  final bool altoContraste;
  final Color corDestaque;
  const ConfirmacaoDenunciaView({super.key, required this.altoContraste, required this.corDestaque});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD2E1D4), Color(0xFFF2F2F2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF59BA15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Denúncia Realizada\ncom Sucesso!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Obrigado por contribuir para uma cidade mais limpa! Você pode acompanhar o status da sua solicitação a qualquer momento.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()),
                        (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "ACOMPANHAR STATUS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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