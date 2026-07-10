import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ColetaLinha {
  DateTime data;
  TimeOfDay hora;
  bool modoDeletar;

  ColetaLinha({
    required this.data,
    required this.hora,
    this.modoDeletar = false,
  });
}

class ColetaAdmin extends StatefulWidget {
  const ColetaAdmin({super.key});

  @override
  State<ColetaAdmin> createState() => _ColetaAdminState();
}

class _ColetaAdminState extends State<ColetaAdmin> {
  final Color greenPrimary = const Color(0xFF1F5C3A);
  final Color backgroundGrey = const Color(0xFFF5F7F6);
  
  int indexSelecionado = 0;
  
  final List<String> nomesMateriais = ['Vidro', 'Plástico', 'Papel', 'Metal', 'Entulho'];
  final List<String> caminhosImagens = [
    'assets/images/vidro.png', 'assets/images/plastico.png', 
    'assets/images/papel.png', 'assets/images/metal.png', 'assets/images/entulho.png'
  ];

  List<ColetaLinha> linhasTabela = [];
  bool carregando = true;
  StreamSubscription? _inscricaoFirebase;

  @override
  void initState() {
    super.initState();
    _escutarHorariosDoMaterial();
  }

  @override
  void dispose() {
    _inscricaoFirebase?.cancel(); 
    super.dispose();
  }

  // 🛠️ ESCUTA EM TEMPO REAL COM METADATA_CHANGES (Instantâneo com Cache)
  void _escutarHorariosDoMaterial() {
    setState(() => carregando = true);
    _inscricaoFirebase?.cancel(); 

    String docId = nomesMateriais[indexSelecionado].toLowerCase();

    // includeMetadataChanges: true força o snapshot a atualizar via cache local imediatamente
    _inscricaoFirebase = FirebaseFirestore.instance
        .collection('cronogramas')
        .doc(docId)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> datasLista = snapshot.data()!['datas'] ?? [];
        if (mounted) {
          setState(() {
            linhasTabela = datasLista.map((item) {
              DateTime dataParsed = DateTime.parse(item['data']);
              List<String> horaMinutos = (item['hora'] as String).split(':');
              return ColetaLinha(
                data: dataParsed,
                hora: TimeOfDay(hour: int.parse(horaMinutos[0]), minute: int.parse(horaMinutos[1])),
              );
            }).toList();
            carregando = false; 
          });
        }
      } else {
        _gerarHorarioPadrao();
      }
    }, onError: (error) {
      debugPrint("Erro na escuta do Firestore: $error");
      _mostrarSnackBar("Erro de permissão ou conexão!", Colors.redAccent);
      _gerarHorarioPadrao();
    });
  }

  void _gerarHorarioPadrao() {
    if (!mounted) return;
    setState(() {
      linhasTabela = [ColetaLinha(data: DateTime.now(), hora: const TimeOfDay(hour: 17, minute: 0))];
      carregando = false;
    });
  }

  // 🚀 ENVIO OTIMIZADO PARA O FIREBASE (Roda inteiramente em Background Thread)
  void _salvarNoFirebase() {
    setState(() {
      linhasTabela.removeWhere((l) => l.modoDeletar);
      if (linhasTabela.isEmpty) {
        linhasTabela.add(ColetaLinha(data: DateTime.now(), hora: const TimeOfDay(hour: 17, minute: 0)));
      }
      carregando = true; 
    });

    String docId = nomesMateriais[indexSelecionado].toLowerCase();
    
    List<Map<String, dynamic>> dadosParaSalvar = linhasTabela.map((linha) {
      String ano = linha.data.year.toString().padLeft(4, '0');
      String mes = linha.data.month.toString().padLeft(2, '0');
      String dia = linha.data.day.toString().padLeft(2, '0');
      
      String hora = linha.hora.hour.toString().padLeft(2, '0');
      String minuto = linha.hora.minute.toString().padLeft(2, '0');

      return {
        'data': '${ano}-${mes}-${dia}T00:00:00.000',
        'hora': '$hora:$minuto',
      };
    }).toList();

    // Executa sem usar 'await', liberando a Main Thread de imediato
    FirebaseFirestore.instance.collection('cronogramas').doc(docId).set({
      'material_index': indexSelecionado,
      'datas': dadosParaSalvar,
    }).then((_) {
      _mostrarSnackBar("Dados salvos com sucesso!", greenPrimary);
    }).catchError((error) {
      debugPrint("Erro ao salvar no Firebase: $error");
      _mostrarSnackBar("Falha ao salvar no banco!", Colors.red);
      if (mounted) setState(() => carregando = false);
    });
  }

  void _mostrarSnackBar(String texto, Color cor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [greenPrimary.withOpacity(0.12), backgroundGrey],
            stops: const [0.0, 0.2],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Configurar Horários",
                          style: TextStyle(color: greenPrimary, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                        ),
                        const Text(
                          "Ajuste os dias e horários do cronograma de coleta",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              _buildLabel("1. SELECIONE O MATERIAL"),
              const SizedBox(height: 8),
              _buildCardBase(
                child: SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: nomesMateriais.length,
                    itemBuilder: (context, index) => _itemMaterial(index),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildLabel("2. MODIFIQUE OS DIAS E HORÁRIOS"),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      color: greenPrimary.withOpacity(0.06),
                      child: Row(
                        children: [
                          Expanded(child: Text("DATA DE COLETA", style: TextStyle(color: greenPrimary, fontWeight: FontWeight.bold, fontSize: 11))),
                          Expanded(child: Text("HORÁRIO", style: TextStyle(color: greenPrimary, fontWeight: FontWeight.bold, fontSize: 11))),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                    carregando 
                      ? const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator()))
                      : _buildTableContent(),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              _buildLabel("PREVIEW EM TEMPO REAL"),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: greenPrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: (linhasTabela.isEmpty || carregando)
                  ? const Text("Carregando cronograma...", style: TextStyle(color: Colors.white))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Material: ${nomesMateriais[indexSelecionado]}", 
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Coleta agendada para às ${linhasTabela[0].hora.format(context)}", 
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)
                            ),
                          ],
                        ),
                        Text(
                          "${linhasTabela[0].data.day.toString().padLeft(2, '0')}/${linhasTabela[0].data.month.toString().padLeft(2, '0')}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 0.5),
    );
  }

  Widget _buildTableContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ...linhasTabela.asMap().entries.map((entry) => _rowInput(entry.key)),
                ],
              ),
            ),
          ),
          const Divider(height: 20, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    linhasTabela.add(ColetaLinha(data: DateTime.now(), hora: TimeOfDay.now()));
                  });
                },
                style: TextButton.styleFrom(foregroundColor: greenPrimary),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Nova Data", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: _salvarNoFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Salvar Horários", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowInput(int index) {
    if (index >= linhasTabela.length) return const SizedBox.shrink();
    final sample = linhasTabela[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: InkWell(
            onTap: () => _selecionarData(index),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: backgroundGrey, borderRadius: BorderRadius.circular(6)),
              child: Text("${sample.data.day.toString().padLeft(2, '0')}/${sample.data.month.toString().padLeft(2, '0')}", 
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          )),
          const SizedBox(width: 8),
          
          Expanded(child: InkWell(
            onTap: () => _selecionarHora(index),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: backgroundGrey, borderRadius: BorderRadius.circular(6)),
              child: Text(sample.hora.format(context), 
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          )),
          const SizedBox(width: 8),
          
          GestureDetector(
            onTap: () => setState(() => sample.modoDeletar = !sample.modoDeletar),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: sample.modoDeletar ? Colors.red.withOpacity(0.1) : backgroundGrey,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                sample.modoDeletar ? Icons.delete_forever_rounded : Icons.delete_outline_rounded,
                color: sample.modoDeletar ? Colors.red : Colors.grey,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarData(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: linhasTabela[index].data, 
      firstDate: DateTime(2024), 
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: greenPrimary)), child: child!),
    );
    if (picked != null) setState(() => linhasTabela[index].data = picked);
  }

  Future<void> _selecionarHora(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: linhasTabela[index].hora,
      builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: greenPrimary)), child: child!),
    );
    if (picked != null) setState(() => linhasTabela[index].hora = picked);
  }

  Widget _itemMaterial(int index) {
    bool selecionado = indexSelecionado == index;
    return GestureDetector(
      onTap: () {
        setState(() => indexSelecionado = index);
        _escutarHorariosDoMaterial(); 
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selecionado ? greenPrimary.withOpacity(0.1) : backgroundGrey, 
                shape: BoxShape.circle, 
                border: Border.all(color: selecionado ? greenPrimary : Colors.transparent, width: 2)
              ),
              child: Image.asset(caminhosImagens[index], width: 36, height: 36, fit: BoxFit.contain),
            ),
            const SizedBox(height: 4),
            Text(
              nomesMateriais[index], 
              style: TextStyle(fontSize: 11, fontWeight: selecionado ? FontWeight.bold : FontWeight.w500, color: selecionado ? greenPrimary : Colors.black54)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBase({required Widget child}) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(12), 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), 
      child: child,
    );
  }
}