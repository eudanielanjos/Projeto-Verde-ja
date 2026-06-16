import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:vibration/vibration.dart'; 
import 'denuncia2_view.dart'; 

class LocalDenunciaPage extends StatefulWidget {
  const LocalDenunciaPage({super.key});

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

  Future<void> _capturarLocalizacaoEAvancar(BuildContext context) async {
    vibrar();
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mostrarErro(context, "O serviço de localização está desativado no seu aparelho.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mostrarErro(context, "Permissão de localização negada pelo usuário.");
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _mostrarErro(context, "Permissão negada permanentemente nas configurações do sistema.");
      return;
    }

    // Indicador de carregamento customizado dentro do padrão visual do app
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const CircularProgressIndicator(color: Color(0xFF1F5C3A)),
        ),
      ),
    );

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (!context.mounted) return;
      Navigator.pop(context); // Fecha o loading

      if (placemarks.isNotEmpty) {
        Placemark lugar = placemarks[0];

        // Mapeamento seguro dos dados do GPS
        Map<String, String> dadosEndereco = {
          'cep': lugar.postalCode ?? "",
          'rua': lugar.thoroughfare ?? "",
          'bairro': lugar.subLocality ?? lugar.subAdministrativeArea ?? "",
          'numero': lugar.subThoroughfare ?? "",
        };

        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Denuncias2(dadosIniciaisEndereco: dadosEndereco),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Garante o fechamento do loading em caso de falha
      _mostrarErro(context, "Erro ao obter coordenadas geográficas: $e");
    }
  }

  void _mostrarErro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem), 
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definição dinâmica de cores com base nas configurações de acessibilidade
    Color corPrincipal;
    Color corFundoGradiente;

    if (altoContraste) {
      corPrincipal = Colors.black;
      corFundoGradiente = Colors.white;
    } else if (daltonismo) {
      corPrincipal = const Color(0xFF455A64);
      corFundoGradiente = const Color(0xFFECEFF1);
    } else {
      corPrincipal = const Color(0xFF1F5C3A);
      corFundoGradiente = const Color(0xFFF0F7F4); 
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [corFundoGradiente, Colors.white],
          ),
        ),
        child: SafeArea( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão superior de voltar integrado ao design fluido
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: corPrincipal), 
                    onPressed: () {
                      vibrar();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Cabeçalho textual estruturado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Local da Denúncia",
                      style: TextStyle(
                        fontSize: 28 * escalaFonte, 
                        fontWeight: FontWeight.w900,
                        color: corPrincipal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Selecione o método de identificação do descarte irregular para darmos andamento à sua solicitação.",
                      style: TextStyle(
                        fontSize: 15 * escalaFonte,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Card unificado que encapsula os seletores de ação
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Opção 1: Captura via Geolocalização ativa
                    _buildOptionButton(
                      context: context,
                      icon: Icons.my_location_rounded,
                      title: "Usar Minha Localização",
                      subtitle: "O preenchimento do endereço será feito via GPS",
                      corTema: corPrincipal,
                      isPrimary: true,
                      onPressed: () => _capturarLocalizacaoEAvancar(context), 
                    ),

                    const SizedBox(height: 18),
                    
                    // Divisor visual centralizado com texto estilizado
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "OU", 
                            style: TextStyle(
                              color: Colors.grey.shade400, 
                              fontSize: 11, 
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // CORREÇÃO: Opção 2 passando mapa vazio para sanar a quebra do construtor
                    _buildOptionButton(
                      context: context,
                      icon: Icons.edit_location_alt_rounded,
                      title: "Digitar endereço",
                      subtitle: "Inserir dados de rua, número e bairro manualmente",
                      corTema: altoContraste ? Colors.black : const Color(0xFF546E7A),
                      isPrimary: false,
                      onPressed: () {
                        vibrar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Denuncias2(dadosIniciaisEndereco: {}), 
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // Componente de botão modular e acessível
  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color corTema,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isPrimary ? corTema : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: !isPrimary && altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withOpacity(0.18) : corTema.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: isPrimary ? Colors.white : corTema, 
                size: 26
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16 * escalaFonte,
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? Colors.white : const Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12 * escalaFonte,
                      color: isPrimary ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded, 
              color: isPrimary ? Colors.white70 : Colors.grey.shade400, 
              size: 14
            ),
          ],
        ),
      ),
    );
  }
}