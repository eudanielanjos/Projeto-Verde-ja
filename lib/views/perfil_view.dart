import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. IMPORTADO O AUTH
import 'package:cloud_firestore/cloud_firestore.dart'; // 2. IMPORTADO O FIRESTORE
import 'package:flutter_app/views/coleta_view.dart';
import 'tela_inicial_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'educacao_view.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Pegamos a instância do usuário logado atualmente no app
  final User? _usuarioAtual = FirebaseAuth.instance.currentUser;

  // Variável para controlar o estado de salvamento no modal
  bool _isSaving = false;

  // Função para deslogar do Firebase Auth com segurança
  Future<void> _fazerLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    }
  }

  File? _imagemPerfil;
  final ImagePicker _picker = ImagePicker();

  // --- ESTADOS DE ACESSIBILIDADE ---
  bool daltonismo = false;
  bool fonteGrande = false;
  bool altoContraste = false;
  bool vibracao = false;
  bool zoomInterface = false;
  double escalaFonte = 1.0;

  @override
  Widget build(BuildContext context) {
    // Se o usuário não estiver logado por algum motivo, exibe um aviso ou redireciona
    if (_usuarioAtual == null) {
      return const Scaffold(
        body: Center(child: Text("Nenhum usuário logado.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      endDrawer: _buildMenuDrawer(context),
      // 🔥 O StreamBuilder escuta as alterações do Firestore em tempo real
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(_usuarioAtual.uid) // Busca o documento com o UID do usuário logado
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados de perfil."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5C3A)),
              ),
            );
          }

          // Se o documento não existir no Firestore, define valores padrão vazios
          Map<String, dynamic> dadosDoBanco = {};
          if (snapshot.hasData && snapshot.data!.exists) {
            dadosDoBanco = snapshot.data!.data() as Map<String, dynamic>;
          }

          // Mapeia os campos retornados ou define strings padrão caso ainda não existam no banco
          String nome = dadosDoBanco['nome'] ?? "Sem Nome";
          String email = dadosDoBanco['email'] ?? _usuarioAtual.email ?? "Sem Email";
          String telefone = dadosDoBanco['telefone'] ?? "Não cadastrado";
          String endereco = dadosDoBanco['endereco'] ?? "Não cadastrado";

          return Column(
            children: [
              // --- HEADER CURVADO ---
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 60, bottom: 40),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F5C3A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildAvatarComFoto(),
                        const SizedBox(height: 15),
                        Text(
                          nome,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 15,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ),
                ],
              ),

              // --- CONTEÚDO (CARDS DINÂMICOS) ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  children: [
                    _buildInfoCard(
                      icon: Icons.phone_android_rounded,
                      title: "Telefone",
                      value: telefone,
                    ),
                    _buildInfoCard(
                      icon: Icons.location_on_outlined,
                      title: "Endereço",
                      value: endereco,
                    ),
                    _buildInfoCard(
                      icon: Icons.lock_outline_rounded,
                      title: "Senha",
                      value: "********",
                    ),
                    const SizedBox(height: 20),
                    
                    // Botão Editar que passa os dados atuais para o modal
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton.icon(
                        onPressed: () => _abrirModalEdicao(context, telefone, endereco),
                        icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                        label: const Text("EDITAR PERFIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F5C3A),
                          fixedSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- FUNCIONALIDADE: MODAL DE EDIÇÃO INTEGRADO AO FIRESTORE ---
  void _abrirModalEdicao(BuildContext context, String telefoneAtual, String enderecoAtual) {
    final telefoneController = TextEditingController(text: telefoneAtual == "Não cadastrado" ? "" : telefoneAtual);
    final enderecoController = TextEditingController(text: enderecoAtual == "Não cadastrado" ? "" : enderecoAtual);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder( // StatefulBuilder serve para atualizar o loading interno do modal
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 25,
                right: 25,
                top: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  const Text("Editar Informações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A))),
                  const SizedBox(height: 25),
                  _buildCampoEdicao(label: "Telefone", controller: telefoneController, icon: Icons.phone),
                  const SizedBox(height: 15),
                  _buildCampoEdicao(label: "Endereço", controller: enderecoController, icon: Icons.map),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            setModalState(() => _isSaving = true);

                            try {
                              // 🔥 ATUALIZA OS DADOS DIRETAMENTE NO FIRESTORE
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(_usuarioAtual!.uid)
                                  .update({
                                'telefone': telefoneController.text.trim(),
                                'endereco': enderecoController.text.trim(),
                              });

                              if (context.mounted) Navigator.pop(context);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erro ao salvar: $e"), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              setModalState(() => _isSaving = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C3A),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("SALVAR ALTERAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarComFoto(Color corTema) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () => _visualizarFotoPerfil(corTema),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFFF1F5F2),
              backgroundImage: _imagemPerfil != null ? FileImage(_imagemPerfil!) : null,
              child: _imagemPerfil == null
                  ? Icon(Icons.person, size: 65, color: corTema)
                  : null,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _tirarFotoOuSelecionarGaleria(corTema),
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: corTema,
                child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoEdicao({required String label, required TextEditingController controller, required IconData icon, required Color corFoco}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: corFoco),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: corFoco), borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon, 
    required String title, 
    required String value, 
    required Color corIcone,
    required double paddingVertical
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: altoContraste ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: paddingVertical),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F2), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: corIcone),
        ),
        title: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF2D312E), fontWeight: FontWeight.bold)),
      ),
    );
  }

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
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, color: Color(0xFF1F5C3A))),
                  ),
                ),
                const SizedBox(height: 10),
                // Exibe o e-mail abreviado ou uma saudação simples no cabeçalho do menu
                Text(_usuarioAtual?.email?.split('@')[0] ?? "Usuário", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildMenuCard(icon: Icons.home, title: "Início", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const TelaInicialView(), replacement: true);
                }),
                _buildMenuCard(icon: Icons.calendar_today, title: "Coleta Regular", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const ColetaView());
                }),
                _buildMenuCard(icon: Icons.school, title: "Educação", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const EducacaoView());
                }),
                _buildMenuCard(icon: Icons.person, title: "Perfil", corTema: corTema, onTap: () => Navigator.pop(context)),
                _buildMenuCard(icon: Icons.history, title: "Histórico de Denúncias", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const HistoricoDenunciasView());
                }),
                _buildMenuCard(icon: Icons.settings, title: "Configurações", corTema: corTema, onTap: () {
                  Navigator.pop(context);
                  navegarParaTela(const ConfiguracaoPage());
                }),
              ],
            ),
          ),
          _buildSairButton(context),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color corTema, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(icon, color: corTema),
            title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.arrow_forward_ios, color: corTema, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _fazerLogout(context), // Alterado para fazer o SignOut correto do Firebase
        child: Container(
          height: 55,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 10),
              Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}