import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔹 Adicionado import que faltava
import 'package:vibration/vibration.dart'; // 🔹 Adicionado import que faltava
import 'denuncia2_view.dart'; 

class LocalDenunciaPage extends StatefulWidget {
  const LocalDenunciaPage({super.key});

  // Função interna para obter a localização atual e converter em endereço básico
  Future<void> _capturarLocalizacaoEAvancar(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de GPS está ativo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mostrarErro(context, "O serviço de localização está desativado.");
      return;
    }

    // Verifica e solicita as permissões de GPS do aparelho
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mostrarErro(context, "Permissão de localização negada.");
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _mostrarErro(context, "Permissão negada permanentemente nas configurações.");
      return;
    }

    // Mostra um indicador de carregamento enquanto busca as coordenadas
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF59BA15))),
    );

    try {
      // Pega a posição geográfica real
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Converte coordenadas em dados textuais de endereço
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      // Fecha o indicador de carregamento
      if (!context.mounted) return;
      Navigator.pop(context); 

      if (placemarks.isNotEmpty) {
        Placemark lugar = placemarks[0];

        // Mapeia os dados recebidos do GPS
        Map<String, String> dadosEndereco = {
          'cep': lugar.postalCode ?? "",
          'rua': lugar.thoroughfare ?? "",
          'bairro': lugar.subLocality ?? lugar.subAdministrativeArea ?? "",
          'numero': lugar.subThoroughfare ?? "",
        };

        // Avança para a próxima tela passando o mapa de dados
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Denuncias2(dadosIniciaisEndereco: dadosEndereco),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Fecha o loading se der erro
      _mostrarErro(context, "Erro ao buscar endereço: $e");
    }
  }

  void _mostrarErro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
    );
  }

  @override
  State<LocalDenunciaPage> createState() => _LocalDenunciaPageState();
}

class _LocalDenunciaPageState extends State<LocalDenunciaPage> {
  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  double escalaFonte = 1.0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F5C3A)), // 🔹 Removido variável inexistente corTextoDestaque
          onPressed: () {
            vibrar();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea( // 🔹 Removido o segundo Scaffold que estava duplicado aqui
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const Spacer(flex: 2), 

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Defina o local de denúncia:",
                style: TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F5C3A),
                  letterSpacing: -0.8,
                ),
              ),
            ),

            const SizedBox(height: 50),

            _buildCenterButton(
              context: context,
              icon: Icons.my_location_rounded,
              text: "Usar Minha Localização",
              corFundo: const Color(0xFF1F5C3A), // 🔹 Ajustado para passar o parâmetro corFundo esperado pelo widget
              onPressed: () => widget._capturarLocalizacaoEAvancar(context), 
            ),

            const SizedBox(height: 20),

            _buildCenterButton(
              context: context,
              icon: Icons.keyboard_rounded,
              text: "Digitar endereço",
              corFundo: Colors.grey.shade600, // 🔹 Ajustado para passar o parâmetro corFundo esperado pelo widget
              onPressed: () {
                vibrar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Denuncias2()), 
                );
              },
            ),

            const Spacer(flex: 3), 
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color corFundo,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, 
      height: 70, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18 * escalaFonte, // Aplicando seu controle de acessibilidade da fonte
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}