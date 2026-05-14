import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaView extends StatefulWidget {
  const MapaView({super.key});

  @override
  State<MapaView> createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  final MapController _mapController = MapController();
  final LatLng _centroBelem = const LatLng(-1.4558, -48.4902);

  // Lista com os 15 pontos de coleta com coordenadas corrigidas em terra firme
  final List<Map<String, dynamic>> _pontosColeta = [
    // --- PLÁSTICO (Vermelho) ---
    {
      "nome": "Ecoponto de Plásticos - Umarizal",
      "tipo": "Plástico",
      "cor": Colors.redAccent,
      "icone": Icons.layers,
      "detalhe": "Aceita garrafas PET, embalagens de shampoo, sacolas limpas e potes plásticos.",
      "coordenadas": const LatLng(-1.4558, -48.4902),
    },
    {
      "nome": "Posto de Coleta Pet - Pedreira",
      "tipo": "Plástico",
      "cor": Colors.redAccent,
      "icone": Icons.layers,
      "detalhe": "Aceita embalagens plásticas variadas, tampinhas e garrafas de bebidas.",
      "coordenadas": const LatLng(-1.4420, -48.4680),
    },
    {
      "nome": "Reciclagem de Plásticos - Jurunas",
      "tipo": "Plástico",
      "cor": Colors.redAccent,
      "icone": Icons.layers,
      "detalhe": "Focado em plásticos duros, engradados vazios e potes domésticos limpos.",
      "coordenadas": const LatLng(-1.4710, -48.4930),
    },

    // --- ENTULHO (Cinza) ---
    {
      "nome": "Ponto de Descarte de Entulhos - Marco",
      "tipo": "Entulho",
      "cor": Colors.blueGrey,
      "icone": Icons.construction,
      "detalhe": "Aceita restos de obras domésticas, tijolos, azulejos e restos de concreto ensacados.",
      "coordenadas": const LatLng(-1.4300, -48.4700),
    },
    {
      "nome": "Área de Descarte Construtivo - Telégrafo",
      "tipo": "Entulho",
      "cor": Colors.blueGrey,
      "icone": Icons.construction,
      "detalhe": "Aceita pequenas quantidades de resíduos de construção civil e restos de azulejos.",
      "coordenadas": const LatLng(-1.4235, -48.4842), // CORRIGIDO: Agora na Av. Senador Lemos
    },
    {
      "nome": "Depósito de Resíduos de Obras - Cremação",
      "tipo": "Entulho",
      "cor": Colors.blueGrey,
      "icone": Icons.construction,
      "detalhe": "Ponto exclusivo para descarte de entulhos ensacados, madeiras de obras e tijolos.",
      "coordenadas": const LatLng(-1.4650, -48.4750),
    },

    // --- VIDRO (Verde) ---
    {
      "nome": "Ponto de Entrega de Vidros - Batista Campos",
      "tipo": "Vidro",
      "cor": Colors.greenAccent,
      "icone": Icons.hourglass_bottom,
      "detalhe": "Aceita garrafas de vidro, potes de conserva e frascos de perfume. Não jogue espelhos.",
      "coordenadas": const LatLng(-1.4600, -48.4850),
    },
    {
      "nome": "Coleta de Vidros e Garrafas - Reduto",
      "tipo": "Vidro",
      "cor": Colors.greenAccent,
      "icone": Icons.hourglass_bottom,
      "detalhe": "Aceita frascos de vidro vazios, copos quebrados e garrafas de bebidas em geral.",
      "coordenadas": const LatLng(-1.4468, -48.4925), // CORRIGIDO: Agora na Av. Visconde de Souza Franco
    },
    {
      "nome": "Ecoponto Vidros - Nazaré",
      "tipo": "Vidro",
      "cor": Colors.greenAccent,
      "icone": Icons.hourglass_bottom,
      "detalhe": "Recipiente seguro para o descarte de potes de vidro, frascos planos e recipientes vazios.",
      "coordenadas": const LatLng(-1.4535, -48.4810),
    },

    // --- PAPEL (Azul) ---
    {
      "nome": "Coleta de Papel e Papelão - Nazaré",
      "tipo": "Papel",
      "cor": Colors.blueAccent,
      "icone": Icons.description,
      "detalhe": "Aceita caixas de papelão desmontadas, jornais, revistas, folhas de caderno e encartes.",
      "coordenadas": const LatLng(-1.4520, -48.4780),
    },
    {
      "nome": "Recicla Papelão e Revistas - Marco",
      "tipo": "Papel",
      "cor": Colors.blueAccent,
      "icone": Icons.description,
      "detalhe": "Aceita caixas de papelão limpas, aparas de papel, livros antigos e panfletos.",
      "coordenadas": const LatLng(-1.4390, -48.4610),
    },
    {
      "nome": "Ponto do Papel Seletivo - Umarizal",
      "tipo": "Papel",
      "cor": Colors.blueAccent,
      "icone": Icons.description,
      "detalhe": "Aceita folhas de papel de escritório, cartolinas, envelopes e caixas de papelão secas.",
      "coordenadas": const LatLng(-1.4620, -48.4940),
    },

    // --- METAL (Amarelo/Laranja) ---
    {
      "nome": "Reciclagem de Metais e Latinhas - Reduto",
      "tipo": "Metal",
      "cor": Colors.orange,
      "icone": Icons.gavel,
      "detalhe": "Aceita latinhas de alumínio, tampas de metal, panelas velhas e fios de cobre.",
      "coordenadas": const LatLng(-1.4425, -48.4945), // CORRIGIDO: Movido para perto da Doca
    },
    {
      "nome": "Ponto de Sucatas e Metais - Pedreira",
      "tipo": "Metal",
      "cor": Colors.orange,
      "icone": Icons.gavel,
      "detalhe": "Aceita esquadrias velhas de alumínio, ferro velho doméstico e tampas metálicas.",
      "coordenadas": const LatLng(-1.4490, -48.4720),
    },
    {
      "nome": "Centro de Coleta de Alumínio - Cremação",
      "tipo": "Metal",
      "cor": Colors.orange,
      "icone": Icons.gavel,
      "detalhe": "Especializado na coleta de latas de bebidas, lacres de alumínio e marmitas limpas.",
      "coordenadas": const LatLng(-1.4590, -48.4690),
    },
  ];

  void _mostrarCardModerno(BuildContext context, Map<String, dynamic> ponto) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ponto["cor"], ponto["cor"].withAlpha(180)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(ponto["icone"], color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ponto["tipo"].toString().toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22, 
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ponto["nome"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "O que descartar aqui?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ponto["detalhe"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pontos de Coleta",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _centroBelem,
          initialZoom: 13, 
          maxZoom: 18,
          minZoom: 8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_app_base',
          ),
          MarkerLayer(
            markers: _pontosColeta.map((ponto) {
              return Marker(
                point: ponto["coordenadas"],
                width: 55,
                height: 55,
                child: GestureDetector(
                  onTap: () => _mostrarCardModerno(context, ponto),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ponto["cor"],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: ponto["cor"].withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      ponto["icone"],
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(_centroBelem, 13), 
        backgroundColor: const Color(0xFF1E293B),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}