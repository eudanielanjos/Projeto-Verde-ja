import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

// Importações das suas views (ajuste os caminhos conforme seu projeto)
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart';
import 'tela_inicial_view.dart';
import 'coleta_view.dart';

class HistoricoDenunciasView extends StatefulWidget {
  const HistoricoDenunciasView({super.key});

  @override
  State<HistoricoDenunciasView> createState() => _HistoricoDenunciasViewState();
}

class _HistoricoDenunciasViewState extends State<HistoricoDenunciasView> {
  final Color greenPrimary = const Color(0xFF1F5C3A);
  bool _tempoLimiteAtingido = false;

  @override
  void initState() {
    super.initState();
    // Força o Firestore a reativar as requisições de rede e ignorar caches travados
    FirebaseFirestore.instance.enableNetwork().catchError((e) => print("Erro ao ativar rede: $e"));
    
    // Se o Firebase não responder em 5 segundos, avisa o usuário em vez de travar a tela
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _tempoLimiteAtingido = true;
        });
      }
    });
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

  // --- PAINEL DE INSPEÇÃO DA DENÚNCIA ---
  void _abrirInspecaoDenuncia(Map<String, dynamic> denuncia, String dataFormatada) {
    final statusColor = _getStatusColor(denuncia["status"] ?? "Pendente");

    String localFormatado = "Local não informado";
    if (denuncia["endereco"] != null) {
      var end = denuncia["endereco"];
      localFormatado = "${end['rua'] ?? ''}, Nº ${end['numero'] ?? 'S/N'} - ${end['bairro'] ?? ''}";
    }

    // Se houver uma foto vinda do Firebase, carrega ela por URL, senão usa a imagem padrão
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
                        borderRadius: BorderRadius.circular(20),
                        border: altoContraste ? Border.all(color: Colors.black) : null,
                        image: DecorationImage(
                          image: fotoDenuncia, 
                          fit: BoxFit.cover,
                        ),
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
                    const SizedBox(height: 20),
                    Text(
                      denuncia["tipo"] ?? "Denúncia Sem Tipo", 
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: greenPrimary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            localFormatado, 
                            style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.person_outline, "Relator", denuncia["usuarioEmail"] ?? "Usuário")),
                        Expanded(child: _buildInfoRow(Icons.calendar_today_outlined, "Data do Registro", dataFormatada)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.info_outline, "STATUS DO PROTOCOLO", denuncia["status"] ?? "Pendente", customColor: statusColor),
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
                        border: Border.all(color: altoContraste ? Colors.black : Colors.grey.shade200),
                      ),
                      child: Text(
                        denuncia["detalhes"] == null || denuncia["detalhes"].toString().isEmpty 
                            ? "Nenhum detalhe adicional fornecido." 
                            : denuncia["detalhes"], 
                        style: const TextStyle(fontSize: 17, height: 1.6, color: Colors.black87),
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

  Widget _buildInfoRow(IconData icon, String label, String value, Color greenPrimary, {Color? customColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 16, color: greenPrimary), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customColor ?? Colors.black87)),
      ],
    );
  }

  String _formatarData(dynamic timestamp) {
    if (timestamp == null) return "Sem data";
    if (timestamp is Timestamp) {
      DateTime dataUtc = timestamp.toDate();
      return "${dataUtc.day.toString().padLeft(2, '0')}/${dataUtc.month.toString().padLeft(2, '0')}/${dataUtc.year}";
    }
    return timestamp.toString();
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: greenPrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text("Sair da Conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? usuarioLogado = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 25),
              decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
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
                  Text(
                    usuarioLogado?.displayName ?? "Olá, Usuário", 
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildMenuCard(icon: Icons.home, title: "Início", onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                  }),
                  _buildMenuCard(icon: Icons.calendar_month, title: "Coleta Regular", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                  }),
                  _buildMenuCard(icon: Icons.school, title: "Educação", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                  }),
                  _buildMenuCard(icon: Icons.history_edu, title: "Histórico de Denúncias", onTap: () => Navigator.pop(context)),
                  _buildMenuCard(icon: Icons.person, title: "Perfil", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                  }),
                  _buildMenuCard(icon: Icons.settings, title: "Configurações", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage()));
                  }),
                ],
              ),
            ),
            _buildSairButton(context),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 25),
                decoration: BoxDecoration(color: greenPrimary),
                child: Column(
                  children: [
                    Icon(Icons.history_edu_rounded, size: 55, color: Colors.white70),
                    SizedBox(height: 10),
                    Text("HISTÓRICO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    Text("Acompanhe todas as solicitações", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildMenuCard(icon: Icons.home, title: "Início", greenPrimary: greenPrimary, onTap: () {
                      vibrar();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                    }),
                    _buildMenuCard(icon: Icons.calendar_month, title: "Coleta Regular", greenPrimary: greenPrimary, onTap: () {
                      vibrar();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                    }),
                    _buildMenuCard(icon: Icons.school, title: "Educação", greenPrimary: greenPrimary, onTap: () {
                      vibrar();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                    }),
                    _buildMenuCard(icon: Icons.history_edu, title: "Histórico de Denúncias", greenPrimary: greenPrimary, onTap: () => Navigator.pop(context)),
                    _buildMenuCard(icon: Icons.person, title: "Perfil", greenPrimary: greenPrimary, onTap: () {
                      vibrar();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                    }),
                    _buildMenuCard(icon: Icons.settings, title: "Configurações", greenPrimary: greenPrimary, onTap: () {
                      vibrar();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage())).then((_) => carregarAcessibilidade());
                    }),
                  ],
                ),
              ),
              _buildSairButton(context),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Filtro adicionado aqui para obedecer à regra de segurança do Firebase
              stream: FirebaseFirestore.instance
                  .collection('denuncias')
                  .where('usuarioId', isEqualTo: usuarioLogado?.uid) 
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
                              "Sem resposta do servidor.\nVerifique sua conexão com a internet ou se você criou o índice composto exigido no log do terminal.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1F5C3A)));
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_late_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Não há nenhuma denúncia registrada.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () => _abrirInspecaoDenuncia(item, greenPrimary), 
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var denuncia = doc.data() as Map<String, dynamic>;
                    String dataFormatada = _formatarData(denuncia['criadoEm']);
                    String status = denuncia['status'] ?? 'Pendente';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(status).withOpacity(0.2),
                          child: Icon(_getStatusIcon(status), color: _getStatusColor(status)),
                        ),
                        title: Text(
                          denuncia['tipo'] ?? 'Sem Tipo',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text("Registrado em: $dataFormatada"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _abrirInspecaoDenuncia(denuncia, dataFormatada),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}