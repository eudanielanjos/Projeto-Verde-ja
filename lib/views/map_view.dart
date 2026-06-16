import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapaView extends StatefulWidget {
  const MapaView({super.key});

  @override
  State<MapaView> createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  final MapController _mapController = MapController();
  final LatLng _centroBelem = const LatLng(-1.4558, -48.4902);
  
  LatLng? _posicaoAtual;
  StreamSubscription<Position>? _positionStreamSubscription;
  String _categoriaSelecionada = "Todos";

  // Lista enriquecida com regras claras de descarte e horários
  final List<Map<String, dynamic>> _pontosColeta = [
    // --- PLÁSTICO ---
    {
      "nome": "Ecoponto de Plásticos - Umarizal",
      "tipo": "Plástico",
      "cor": Colors.redAccent,
      "icone": Icons.layers,
      "pode": "Garrafas PET, embalagens de shampoo, sacolas limpas, potes plásticos e frascos de detergente.",
      "nao_pode": "Embalagens de óleo motor, isopores sujos, tomadas e plásticos metalizados (salgadinhos).",
      "coordenadas": const LatLng(-1.4558, -48.4902),
    },
    {
      "nome": "Posto de Coleta Pet - Pedreira",
      "tipo": "Plástico",
      "cor": Colors.redAccent,
      "icone": Icons.layers,
      "pode": "Garrafas de refrigerante/água, tampinhas plásticas e galões de água vazios.",
      "nao_pode": "Brinquedos quebrados, canos de PVC e fraldas descartáveis.",
      "coordenadas": const LatLng(-1.4420, -48.4680),
    },

    // --- ENTULHO ---
    {
      "nome": "Ponto de Descarte de Entulhos - Marco",
      "tipo": "Entulho",
      "cor": Colors.blueGrey,
      "icone": Icons.construction,
      "pode": "Restos de obras domésticas, tijolos, azulejos quebrados, telhas e restos de concreto ensacados.",
      "nao_pode": "Lixo eletrônico, tintas, solventes, amianto e lâmpadas fluorescentes.",
      "coordenadas": const LatLng(-1.4300, -48.4700),
    },
    {
      "nome": "Área de Descarte Construtivo - Telégrafo",
      "tipo": "Entulho",
      "cor": Colors.blueGrey,
      "icone": Icons.construction,
      "pode": "Madeiras de obra, gesso ensacado, blocos de cerâmica e argamassa seca.",
      "nao_pode": "Móveis inteiros, galhos de árvores e lixo doméstico orgânico.",
      "coordenadas": const LatLng(-1.4235, -48.4842),
    },

    // --- VIDRO ---
    {
      "nome": "Ponto de Entrega de Vidros - Batista Campos",
      "tipo": "Vidro",
      "cor": Colors.green,
      "icone": Icons.hourglass_bottom,
      "pode": "Garrafas de vidro inteiras, potes de conserva lavados e frascos de perfume vazios.",
      "nao_pode": "Espelhos, vidros de janela, cristais, lâmpadas e porcelanas/cerâmicas.",
      "coordenadas": const LatLng(-1.4600, -48.4850),
    },
    {
      "nome": "Ecoponto Vidros - Nazaré",
      "tipo": "Vidro",
      "cor": Colors.green,
      "icone": Icons.hourglass_bottom,
      "pode": "Copos de vidro (mesmo quebrados, desde que protegidos), potes de papinha e frascos de remédio limpos.",
      "nao_pode": "Tubos de TV, parabrisas de carros e cerâmicas em geral.",
      "coordenadas": const LatLng(-1.4535, -48.4810),
    },

    // --- PAPEL ---
    {
      "nome": "Coleta de Papel e Papelão - Nazaré",
      "tipo": "Papel",
      "cor": Colors.blueAccent,
      "icone": Icons.description,
      "pode": "Caixas de papelão desmontadas, jornais, revistas, folhas de caderno, listas telefônicas e envelopes.",
      "nao_pode": "Papel higiênico, guardanapos sujos de gordura, fitas adesivas e fotografias.",
      "coordenadas": const LatLng(-1.4520, -48.4780),
    },

    // --- METAL ---
    {
      "nome": "Reciclagem de Metais e Latinhas - Reduto",
      "tipo": "Metal",
      "cor": Colors.orangeAccent,
      "icone": Icons.gavel,
      "pode": "Latinhas de alumínio, tampas de metal de potes, panelas velhas sem cabo plástico e fios de cobre.",
      "nao_pode": "Latas de tinta aerosol cheias, pilhas, baterias e embalagens de inseticidas.",
      "coordenadas": const LatLng(-1.4425, -48.4945),
    },
  ];

  @override
  void initState() {
    super.initState();
    _iniciarMonitoramentoLocalizacao();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _iniciarMonitoramentoLocalizacao() async {
    bool servicoAtivo;
    LocationPermission permissao;

    servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) return;

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) return;
    }
    
    if (permissao == LocationPermission.deniedForever) return;

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _posicaoAtual = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  void _centralizarNoUsuario() {
    if (_posicaoAtual != null) {
      _mapController.move(_posicaoAtual!, 15);
    } else {
      _mapController.move(_centroBelem, 13);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Buscando sinal do GPS..."),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Substituído por um Modal Inferior Estilo Google Maps (Mais limpo e profissional)
  void _mostrarPainelInformativo(BuildContext context, Map<String, dynamic> ponto) {
    final Color corBase = ponto["cor"] as Color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de arrastar do modal
              Center(
                child: Container(
                  width: 45,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Título e Categoria Tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ponto["nome"].toString(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: corBase.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ponto["tipo"].toString().toUpperCase(),
                            style: TextStyle(color: corBase, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: corBase,
                    radius: 24,
                    child: Icon(ponto["icone"] as IconData, color: Colors.white, size: 24),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              const Divider(),


              const SizedBox(height: 10),


              const SizedBox(height: 20),

              // Seção: O que PODE levar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("O QUE RECEBEMOS:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 0.3)),
                          const SizedBox(height: 4),
                          Text(ponto["pode"].toString(), style: TextStyle(fontSize: 13, color: Colors.green.shade900, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Seção: O que NÃO PODE levar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("O QUE NÃO LEVAR:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 0.3)),
                          const SizedBox(height: 4),
                          Text(ponto["nao_pode"].toString(), style: TextStyle(fontSize: 13, color: Colors.red.shade900, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de categorias para a barra de filtros superior
    final List<String> categorias = ["Todos", "Plástico", "Vidro", "Papel", "Metal", "Entulho"];

    // Aplica o filtro de categoria selecionada em tempo de execução
    final List<Map<String, dynamic>> pontosFiltrados = _categoriaSelecionada == "Todos"
        ? _pontosColeta
        : _pontosColeta.where((p) => p["tipo"] == _categoriaSelecionada).toList();

    // Transforma os dados filtrados em marcadores visuais para o OpenStreetMap
    final List<Marker> listMarkers = pontosFiltrados.map<Marker>((ponto) {
      final Color corPonto = ponto["cor"] as Color;
      return Marker(
        point: ponto["coordenadas"] as LatLng,
        width: 48,
        height: 48,
        child: GestureDetector(
          onTap: () => _mostrarPainelInformativo(context, ponto),
          child: Container(
            decoration: BoxDecoration(
              color: corPonto,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(ponto["icone"] as IconData, color: Colors.white, size: 20),
          ),
        ),
      );
    }).toList();

    // Renderiza a localização em tempo real do dispositivo do usuário
    if (_posicaoAtual != null) {
      listMarkers.add(
        Marker(
          point: _posicaoAtual!,
          width: 32,
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pontos de Coleta Ecológica",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        backgroundColor: const Color(0xFF1F5C3A),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camada do Mapa Integrada
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centroBelem,
              initialZoom: 13.5, 
              maxZoom: 18,
              minZoom: 8,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_app_base',
              ),
              MarkerLayer(markers: listMarkers),
            ],
          ),

          // Barra Superior de Filtros Rápidos (Chips)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final cat = categorias[index];
                  final bool isSelected = _categoriaSelecionada == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1F5C3A),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                      elevation: 2,
                      pressElevation: 0,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() => _categoriaSelecionada = cat);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centralizarNoUsuario, 
        backgroundColor: const Color(0xFF1E293B),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}