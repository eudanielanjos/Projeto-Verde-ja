import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

// Importações das suas views
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart' as config;
import 'tela_inicial_view.dart';
import 'coleta_view.dart';
import 'home_view.dart';

class HistoricoDenunciasView extends StatefulWidget {
  const HistoricoDenunciasView({super.key});

  @override
  State<HistoricoDenunciasView> createState() => _HistoricoDenunciasViewState();
}

class _HistoricoDenunciasViewState extends State<HistoricoDenunciasView> {
  final User? _usuarioAtual = FirebaseAuth.instance.currentUser;
  bool _tempoLimiteAtingido = false;

  // Variáveis de acessibilidade integradas da tela de perfil
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  bool zoomInterface = false;
  double escalaFonte = 1.0;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
    
    // Força o Firestore a reativar as requisições de rede
    FirebaseFirestore.instance.enableNetwork().catchError((e) => print("Erro ao ativar rede: $e"));
    
    // Timer de segurança para conexões lentas
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _tempoLimiteAtingido = true;
        });
      }
    });
  }

  Future<void> _carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      daltonismo = prefs.getBool('daltonismo') ?? false;
      fonteGrande = prefs.getBool('fonteGrande') ?? false;
      altoContraste = prefs.getBool('altoContraste') ?? false;
      vibracao = prefs.getBool('vibracao') ?? false;
      zoomInterface = prefs.getBool('zoomInterface') ?? false;
      escalaFonte = fonteGrande ? 1.25 : 1.0;
    });
  }

  void _vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  void navegarParaTela(Widget tela, {bool replacement = false}) {
    _vibrar();
    if (replacement) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => tela));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolvido": return const Color(0xFF59BA15);
      case "em análise": 
      case "pendente": return Colors.orange;
      case "recusado": return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "resolvido": return Icons.check_circle_rounded;
      case "em análise":
      case "pendente": return Icons.pending_actions_rounded;
      case "recusado": return Icons.cancel_rounded;
      default: return Icons.info_rounded;
    }
  }

  String _formatarData(dynamic timestamp) {
    if (timestamp == null) return "Sem data";
    if (timestamp is Timestamp) {
      DateTime dataUtc = timestamp.toDate();
      return "${dataUtc.day.toString().padLeft(2, '0')}/${dataUtc.month.toString().padLeft(2, '0')}/${dataUtc.year}";
    }
    return timestamp.toString();
  }

  // --- PAINEL DE INSPEÇÃO DA DENÚNCIA REESTILIZADO ---
  void _abrirInspecaoDenuncia(Map<String, dynamic> denuncia, String dataFormatada, Color corTema) {
    _vibrar();
    final statusColor = _getStatusColor(denuncia["status"] ?? "Pendente");

    String localFormatado = "Local não informado";
    if (denuncia["endereco"] != null) {
      var end = denuncia["endereco"];
      localFormatado = "${end['rua'] ?? ''}, Nº ${end['numero'] ?? 'S/N'} - ${end['bairro'] ?? ''}";
    }

    ImageProvider fotoDenuncia = const AssetImage("assets/images/descarte.png");
    if (denuncia["imageUrl"] != null && denuncia["imageUrl"].toString().isNotEmpty) {
      fotoDenuncia = NetworkImage(denuncia["imageUrl"]);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(22),
                        border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
                        image: DecorationImage(image: fotoDenuncia, fit: BoxFit.cover),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (denuncia["status"] ?? "PENDENTE").toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      denuncia["tipo"] ?? "Denúncia Sem Tipo", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: corTema),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            localFormatado, 
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.person_outline, "Relator", denuncia["usuarioEmail"] ?? "Usuário", corTema)),
                        Expanded(child: _buildInfoRow(Icons.calendar_today_outlined, "Data de Registro", dataFormatada, corTema)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.info_outline, "STATUS DO PROTOCOLO", denuncia["status"] ?? "Pendente", corTema, customColor: statusColor),
                    const SizedBox(height: 30),
                    const Text(
                      "DETALHES TÉCNICOS / MOTIVO", 
                      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 13, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7F6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: altoContraste ? Colors.black : Colors.grey.shade200, width: altoContraste ? 2 : 1),
                      ),
                      child: Text(
                        denuncia["detalhes"] == null || denuncia["detalhes"].toString().isEmpty 
                            ? "Nenhum detalhe adicional fornecido." 
                            : denuncia["detalhes"], 
                        style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color corTema, {Color? customColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: corTema), 
            const SizedBox(width: 5), 
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))
          ],
        ),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: customColor ?? Colors.black87)),
      ],
    );
  }

  // --- MENU DRAWER COPIADO DA TELA INICIAL ---
  Widget _buildMenuDrawer(BuildContext context, Color corTema) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: BoxDecoration(color: corTema),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Olá, Usuario",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildMenuCard(
                  icon: Icons.home,
                  title: "Início",
                  corIcone: corTema,
                  onTap: () {
                    _vibrar();
                    Navigator.pop(context);
                    navegarParaTela(const TelaInicialView(), replacement: true);
                  },
                ),
                _buildMenuCard(
                  icon: Icons.calendar_month,
                  title: "Coleta Regular",
                  corIcone: corTema,
                  onTap: () {
                    Navigator.pop(context);
                    navegarParaTela(const ColetaView());
                  },
                ),
                _buildMenuCard(
                  icon: Icons.school,
                  title: "Educação",
                  corIcone: corTema,
                  onTap: () {
                    Navigator.pop(context);
                    navegarParaTela(const EducacaoView());
                  },
                ),
                _buildMenuCard(
                  icon: Icons.history_edu,
                  title: "Histórico de Denúncias",
                  corIcone: corTema,
                  onTap: () {
                    _vibrar();
                    Navigator.pop(context); 
                  },
                ),
                _buildMenuCard(
                  icon: Icons.person,
                  title: "Perfil",
                  corIcone: corTema,
                  onTap: () {
                    Navigator.pop(context);
                    navegarParaTela(const PerfilPage());
                  },
                ),
                _buildMenuCard(
                  icon: Icons.settings,
                  title: "Configurações",
                  corIcone: corTema,
                  onTap: () {
                    Navigator.pop(context);
                    navegarParaTela(const config.ConfiguracaoPage());
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                _vibrar();
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                    (route) => false,
                  );
                }
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Sair da conta",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corIcone, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: corIcone),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                Icon(Icons.arrow_forward_ios, color: corIcone, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color corTema;
    if (altoContraste) {
      corTema = Colors.black;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64);
    } else {
      corTema = const Color(0xFF1F5C3A);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        endDrawer: _buildMenuDrawer(context, corTema),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60, bottom: 35),
                  decoration: BoxDecoration(
                    color: corTema,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.history_edu_rounded, size: 55, color: Colors.white70),
                      SizedBox(height: 10),
                      Text("HISTÓRICO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      Text("Acompanhe todas as solicitações", style: TextStyle(color: Colors.white70, fontSize: 15)),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 15,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () {
                        _vibrar();
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('denuncias')
                    .where('usuarioId', isEqualTo: _usuarioAtual?.uid) 
                    .orderBy('criadoEm', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Erro do Firebase:\n${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    if (_tempoLimiteAtingido) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_off, size: 50, color: Colors.orange),
                              SizedBox(height: 10),
                              Text(
                                "Sem resposta do servidor.\nVerifique sua conexão com a internet.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator(color: corTema));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_late_outlined, size: 60, color: Colors.grey),
                          SizedBox(height: 15),
                          Text(
                            "Não há nenhuma denúncia registrada.",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: zoomInterface ? 25 : 15),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var denuncia = doc.data() as Map<String, dynamic>;
                      String dataFormatada = _formatarData(denuncia['criadoEm']);
                      String status = denuncia['status'] ?? 'Pendente';
                      final statusCor = _getStatusColor(status);

                      // O widget AnimatedScale ou Transform.scale aplica o zoom visual de acessibilidade na lista de itens
                      return AnimatedScale(
                        scale: zoomInterface ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: ListTile(
                            onTap: () => _abrirInspecaoDenuncia(denuncia, dataFormatada, corTema),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: zoomInterface ? 14 : 6),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: statusCor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(_getStatusIcon(status), color: statusCor, size: 26),
                            ),
                            title: Text(
                              denuncia['tipo'] ?? 'Sem Tipo',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D312E)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Registrado em: $dataFormatada",
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black26),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}