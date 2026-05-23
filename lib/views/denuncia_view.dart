import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'denuncia2_view.dart'; 

class LocalDenunciaPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD2E1D4), 
              Color(0xFFF2F2F2),
              Color(0xFFF2F2F2),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
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
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              _buildCenterButton(
                context: context,
                icon: Icons.my_location_rounded,
                text: "Usar Minha Localização",
                isPrimary: true,
                onPressed: () => _capturarLocalizacaoEAvancar(context), // 🔹 Nova lógica acoplada aqui
              ),

              const SizedBox(height: 20),

              _buildCenterButton(
                context: context,
                icon: Icons.keyboard_rounded,
                text: "Digitar endereço",
                isPrimary: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Denuncias2()), // 🔹 Abre vazio por padrão
                  );
                },
              ),

              const Spacer(flex: 3), 
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, 
      height: 70, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPrimary 
                ? const Color(0xFF59BA15).withOpacity(0.3) 
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF59BA15) : const Color(0xFF63866C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}