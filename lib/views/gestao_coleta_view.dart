import 'package:flutter/material.dart';

// Modelo de dados para as linhas da tabela
class ColetaLinha {
  DateTime data;
  TimeOfDay hora;
  String bairro;
  bool modoDeletar; // Controla se o ícone é lápis ou lixeira

  ColetaLinha({
    required this.data,
    required this.hora,
    required this.bairro,
    this.modoDeletar = false,
  });
}

class ColetaAdmin extends StatefulWidget {
  const ColetaAdmin({super.key});

  @override
  State<ColetaAdmin> createState() => _ColetaAdminState();
}

class _ColetaAdminState extends State<ColetaAdmin> {
  final Color greenBg = const Color(0xFF1B4332);
  final Color greenHeaderTable = const Color(0xFF6A8E7F);
  
  int indexSelecionado = 0;
  final List<String> bairrosDisponiveis = ["Umarizal", "Terra Firme", "Guamá", "Pedreira"];
  final List<String> nomesMateriais = ['Papel', 'Metal', 'Plástico', 'Vidro', 'Entulho'];
  final List<String> caminhosImagens = [
    'assets/images/papel.png', 'assets/images/metal.png', 
    'assets/images/plastico.png', 'assets/images/vidro.png', 'assets/images/entulho.png'
  ];

  // Lista dinâmica da tabela
  List<ColetaLinha> linhasTabela = [
    ColetaLinha(data: DateTime.now(), hora: const TimeOfDay(hour: 17, minute: 0), bairro: "Umarizal"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gestão de coletas",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 1. CARD HISTÓRICO
            _buildWhiteCard(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Histórico de coletas", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                  Icon(Icons.arrow_circle_right, color: Colors.black, size: 28),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 2. CARD SELEÇÃO DE MATERIAL
            _buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selecione o material", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nomesMateriais.length,
                      itemBuilder: (context, index) => _itemMaterial(index),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 3. TABELA DE INSERÇÃO (QUADRADINHOS EDITÁVEIS)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8DA38A).withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF94A876), width: 2),
              ),
              child: Column(
                children: [
                  // Cabeçalho da Tabela
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: greenHeaderTable,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Center(child: Text("Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                        Expanded(child: Center(child: Text("Hora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                        Expanded(flex: 2, child: Center(child: Text("Bairro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                        Expanded(child: Center(child: Text("Editar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                      ],
                    ),
                  ),
                  _buildTableContent(),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 4. CARD INFORMAÇÕES DATA ATUAL
            _buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ver atividades na data atual", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                      Icon(Icons.radio_button_off, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${linhasTabela[0].data.day.toString().padLeft(2, '0')}/${linhasTabela[0].data.month.toString().padLeft(2, '0')}", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B4332))
                  ),
                  Text("Material: ${nomesMateriais[indexSelecionado]}", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  Text("Bairro: ${linhasTabela[0].bairro}", style: const TextStyle(color: Colors.grey)),
                  Text("Horário: ${linhasTabela[0].hora.format(context)}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

Widget _buildTableContent() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
    ),
    child: Column(
      children: [
        // Envolvemos as linhas em um ScrollView com altura limitada
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 150, // Altura suficiente para mostrar 3 linhas
          ),
          child: Scrollbar( // Adiciona a barrinha de scroll visual
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...linhasTabela.asMap().entries.map((entry) => _rowInput(entry.key)).toList(),
                ],
              ),
            ),
          ),
        ),
        
        const Divider(height: 20, thickness: 1), // Linha separadora discreta
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1B4332)),
              onPressed: () {
                setState(() {
                  linhasTabela.add(ColetaLinha(data: DateTime.now(), hora: TimeOfDay.now(), bairro: "Umarizal"));
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  linhasTabela.removeWhere((l) => l.modoDeletar);
                  if (linhasTabela.isEmpty) {
                    linhasTabela.add(ColetaLinha(data: DateTime.now(), hora: TimeOfDay.now(), bairro: "Umarizal"));
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A80F0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Atualizar", style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    ),
  );
}

  Widget _rowInput(int index) {
    final linha = linhasTabela[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // DATA
          Expanded(child: _quadradinho(
            child: Text("${linha.data.day}/${linha.data.month}", style: const TextStyle(fontSize: 12)),
            onTap: () => _selecionarData(index),
          )),
          // HORA
          Expanded(child: _quadradinho(
            child: Text(linha.hora.format(context), style: const TextStyle(fontSize: 12)),
            onTap: () => _selecionarHora(index),
          )),
          // BAIRRO (VERDE)
          Expanded(flex: 2, child: _quadradinho(
            color: const Color(0xFF6A8E7F),
            onTap: () => _mostrarMenuBairros(index),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(linha.bairro, style: const TextStyle(color: Colors.white, fontSize: 11)),
                const Icon(Icons.arrow_drop_down, color: Colors.white, size: 14),
              ],
            ),
          )),
          // EDITAR / LIXEIRA
          Expanded(child: GestureDetector(
            onTap: () => setState(() => linha.modoDeletar = !linha.modoDeletar),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 35,
              decoration: BoxDecoration(
                color: linha.modoDeletar ? Colors.red[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                linha.modoDeletar ? Icons.delete_forever : Icons.edit,
                color: linha.modoDeletar ? Colors.red : Colors.grey[700],
                size: 18,
              ),
            ),
          )),
        ],
      ),
    );
  }

  // Widget auxiliar para criar os quadradinhos da tabela
  Widget _quadradinho({required Widget child, required VoidCallback onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }

  // Métodos de suporte
  void _mostrarMenuBairros(int index) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 300, 20, 0),
      items: bairrosDisponiveis.map((b) => PopupMenuItem(value: b, child: Text(b))).toList(),
    ).then((value) {
      if (value != null) setState(() => linhasTabela[index].bairro = value);
    });
  }

  Future<void> _selecionarData(int index) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: linhasTabela[index].data, firstDate: DateTime(2024), lastDate: DateTime(2030));
    if (picked != null) setState(() => linhasTabela[index].data = picked);
  }

  Future<void> _selecionarHora(int index) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: linhasTabela[index].hora);
    if (picked != null) setState(() => linhasTabela[index].hora = picked);
  }

  Widget _itemMaterial(int index) {
    bool selecionado = indexSelecionado == index;
    return GestureDetector(
      onTap: () => setState(() => indexSelecionado = index),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: selecionado ? Colors.green.withOpacity(0.2) : Colors.grey[100], shape: BoxShape.circle, border: Border.all(color: selecionado ? Colors.green : Colors.transparent, width: 2)),
            child: Image.asset(caminhosImagens[index], width: 45, height: 45, fit: BoxFit.contain),
          ),
          const SizedBox(height: 5),
          Text(nomesMateriais[index], style: TextStyle(fontSize: 11, fontWeight: selecionado ? FontWeight.bold : FontWeight.normal)),
        ]),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]), child: child);
  }
}