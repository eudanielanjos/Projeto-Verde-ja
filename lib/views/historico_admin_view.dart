import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoAdminView extends StatefulWidget {
  const HistoricoAdminView({super.key});

  @override
  State<HistoricoAdminView> createState() => _HistoricoAdminViewState();
}

class _HistoricoAdminViewState extends State<HistoricoAdminView> {
  final Color greenPrimary = const Color(0xFF1B4D2E);
  final Color greenAccent = const Color(0xFF59BA15);
  String _filtroSelecionado = "Todas";

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolvido": return greenAccent;
      case "em análise":
      case "pendente": return Colors.orange;
      case "recusado": return Colors.red;
      default: return Colors.grey;
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

  @override
  Widget build(BuildContext context) {
    // Escuta em tempo real o estado da autenticação (corrige o problema pós-logout)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, authSnapshot) {
        // Se o Firebase ainda estiver processando quem está logado na inicialização
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Color(0xFF1B4D2E))),
          );
        }

        final user = authSnapshot.data;

        // VALIDAÇÃO SEGURA: Se não houver usuário OU se o email logado não for o admin
        if (user == null || user.email != 'verdejaprojeto@gmail.com') {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                // Adicionado SingleChildScrollView para evitar overflow em telas muito pequenas
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_person_outlined, size: 80, color: Colors.red),
                      const SizedBox(height: 20),
                      const Text(
                        "Acesso Restrito",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user == null 
                          ? "Você precisa fazer login no aplicativo com o e-mail verdejaprojeto@gmail.com para acessar este painel."
                          : "A conta '${user.email}' não tem permissão de administrador.\n\nPor favor, entre com a conta verdejaprojeto@gmail.com.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: greenPrimary),
                        onPressed: () async {
                          // Se houver uma conta incorreta salva no cache, limpa ela
                          if (user != null) {
                            await FirebaseAuth.instance.signOut();
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text("Voltar para o Login", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // --- SE ESTIVER LOGADO COM SUCESSO, CARREGA O PAINEL ADMIN NORMALMENTE ---
        debugPrint("====================================================");
        debugPrint("EMAIL CONFIRMADO PELO STREAM: ${user.email}");
        debugPrint("UID CONFIRMADO PELO STREAM: ${user.uid}");
        debugPrint("====================================================");

        // Consulta ordenando os dados pela data de criação
        Query queryBase = FirebaseFirestore.instance.collection('denuncias').orderBy('criadoEm', descending: true);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F6),
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: queryBase.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // Se o Firebase rejeitar por segurança, exibe o aviso na tela de forma amigável
                      if (snapshot.error.toString().contains('permission-denied')) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_person_outlined, size: 60, color: Colors.red),
                                const SizedBox(height: 15),
                                Text(
                                  "Acesso Negado (Firebase Rules)",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red.shade800),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "O e-mail '${user.email}' não tem autorização para ler todas as denúncias.\n\nVerifique se as Regras de Segurança no console do Firebase liberam o e-mail exato dele.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // Fallback sem ordenação (caso o índice composto ainda não tenha sido criado)
                      return _buildStreamSemOrdenacao();
                    }
                    
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: greenPrimary));
                    }
                    
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Nenhuma ocorrência encontrada no banco."));
                    }

                    return _buildListaDenuncias(snapshot.data!.docs);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreamSemOrdenacao() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('denuncias').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Erro de Permissão: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: greenPrimary));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Nenhuma ocorrência encontrada."));
        }
        return _buildListaDenuncias(snapshot.data!.docs);
      },
    );
  }

  Widget _buildListaDenuncias(List<QueryDocumentSnapshot> docs) {
    List<Map<String, dynamic>> listaCompleta = docs.map((doc) {
      final dados = doc.data() as Map<String, dynamic>? ?? {};
      final Map<String, dynamic> mapaTratado = Map<String, dynamic>.from(dados);
      mapaTratado['docId'] = doc.id;
      return mapaTratado;
    }).toList();

    // Filtro em memória baseado na seleção das pílulas no cabeçalho
    List<Map<String, dynamic>> listaFiltrada = listaCompleta.where((denuncia) {
      if (_filtroSelecionado == "Todas") return true;
      String statusStr = (denuncia["status"] ?? "Pendente").toString().toLowerCase();
      
      if (_filtroSelecionado == "Em análise") {
        return statusStr == "em análise" || statusStr == "pendente";
      }
      return statusStr == _filtroSelecionado.toLowerCase();
    }).toList();

    if (listaFiltrada.isEmpty) {
      return const Center(child: Text("Nenhuma ocorrência neste filtro."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: listaFiltrada.length,
      itemBuilder: (context, index) {
        return _buildAdminCard(listaFiltrada[index]);
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: greenPrimary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text("PAINEL ADMIN", 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 65,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                children: [
                  _buildFilterPill("Todas", Icons.all_inclusive),
                  _buildFilterPill("Em análise", Icons.hourglass_empty),
                  _buildFilterPill("Resolvido", Icons.check_circle_outline),
                  _buildFilterPill("Recusado", Icons.highlight_off),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, IconData icon) {
    bool isSelected = _filtroSelecionado == label;
    return GestureDetector(
      onTap: () => setState(() => _filtroSelecionado = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? greenPrimary : Colors.white),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? greenPrimary : Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> item) {
    String status = item["status"] ?? "Pendente";
    String tipo = item["tipo"] ?? item["titulo"] ?? "Sem Tipo";
    String dataFormatada = _formatarData(item['criadoEm'] ?? item['data']);
    String fotoPerfil = item["usuarioFoto"] ?? "https://i.pravatar.cc/150?img=11"; 

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          radius: 25, 
          backgroundImage: NetworkImage(fotoPerfil),
          backgroundColor: Colors.grey.shade200,
        ),
        title: Text(tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${item["usuarioEmail"] ?? item["email"] ?? 'Usuário'} • $dataFormatada",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.circle, color: _getStatusColor(status), size: 12),
        onTap: () => _abrirDetalhesDenuncia(item),
      ),
    );
  }

  void _abrirDetalhesDenuncia(Map<String, dynamic> denuncia) {
    String status = denuncia["status"] ?? "Pendente";
    String dataFormatada = _formatarData(denuncia['criadoEm'] ?? denuncia['data']);
    String tipo = denuncia["tipo"] ?? denuncia["titulo"] ?? "Sem Tipo";
    
    String localFormatado = "Local não informado";
    if (denuncia["endereco"] != null) {
      var end = denuncia["endereco"];
      localFormatado = "${end['rua'] ?? ''}, Nº ${end['numero'] ?? 'S/N'} - ${end['bairro'] ?? ''}";
    } else if (denuncia["localizacao"] != null) {
      localFormatado = denuncia["localizacao"].toString();
    }

    String detalhesText = denuncia["detalhes"] ?? 
                          denuncia["motivo"] ?? 
                          denuncia["descricao"] ?? 
                          "Nenhum detalhe fornecido.";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECE9), 
                        borderRadius: BorderRadius.circular(20),
                        image: denuncia["imageUrl"] != null && denuncia["imageUrl"].toString().isNotEmpty
                            ? DecorationImage(image: NetworkImage(denuncia["imageUrl"]), fit: BoxFit.cover)
                            : null,
                      ),
                      child: denuncia["imageUrl"] != null && denuncia["imageUrl"].toString().isNotEmpty
                          ? Align(
                              alignment: Alignment.topRight, 
                              child: Padding(
                                padding: const EdgeInsets.all(12), 
                                child: _statusBadge(status),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported_outlined, size: 45, color: greenPrimary.withOpacity(0.5)),
                                  const SizedBox(height: 8),
                                  Text("Sem imagem anexada", style: TextStyle(color: greenPrimary.withOpacity(0.6), fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(tipo, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: greenPrimary)),
                    Text(localFormatado, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    const Divider(height: 40),
                    
                    // Ajustado com flex ou espaçamento controlado para evitar overflows com emails longos
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _infoDetail(Icons.person_outline, "Relator", denuncia["usuarioEmail"] ?? denuncia["email"] ?? "Usuário"),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: _infoDetail(Icons.calendar_today_outlined, "Data Registro", dataFormatada),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _infoDetail(
                      Icons.info_outline, 
                      "STATUS ATUAL", 
                      status.toUpperCase(), 
                      customColor: _getStatusColor(status)
                    ),
                    
                    const SizedBox(height: 25),
                    const Text("MOTIVO DA OCORRÊNCIA", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 11, letterSpacing: 1.1)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7F6), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
                      child: Text(
                        detalhesText, 
                        style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenPrimary, 
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                        elevation: 0,
                      ),
                      onPressed: () => _mostrarMenuStatus(denuncia),
                      child: const Text("GERENCIAR STATUS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
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

  void _mostrarMenuStatus(Map<String, dynamic> denuncia) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(margin: const EdgeInsets.only(bottom: 15), width: 35, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const Text("ALTERAR STATUS PARA:", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            _statusOption(Icons.hourglass_empty, "Em análise", Colors.orange, denuncia),
            _statusOption(Icons.check_circle_outline, "Resolvido", greenAccent, denuncia),
            _statusOption(Icons.highlight_off, "Recusado", Colors.red, denuncia),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(IconData icon, String label, Color color, Map<String, dynamic> denuncia) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () async {
        String? docId = denuncia['docId'];

        if (docId != null) {
          try {
            await FirebaseFirestore.instance
                .collection('denuncias')
                .doc(docId)
                .update({'status': label});

            if (mounted) {
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Status alterado para '$label' com sucesso!"),
                  backgroundColor: greenPrimary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erro ao atualizar: $e"), backgroundColor: Colors.red),
              );
            }
          }
        }
      },
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoDetail(IconData icon, String label, String value, {Color? customColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: greenPrimary), 
            const SizedBox(width: 5), 
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: customColor ?? Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}