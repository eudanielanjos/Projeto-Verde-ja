import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'coleta_view.dart';
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
  final User? _usuarioAtual = FirebaseAuth.instance.currentUser;
  bool _isSaving = false;

  File? _imagemPerfil;
  final ImagePicker _picker = ImagePicker();

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
      if (await Vibration.hasVibrator() && await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

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

  Future<void> _tirarFotoOuSelecionarGaleria(Color corTema) async {
    _vibrar();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: corTema),
              title: const Text('Galeria'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() => _imagemPerfil = File(image.path));
                  }
                } catch (e) {
                  _mostrarErroAcesso(e.toString());
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera, color: corTema),
              title: const Text('Câmera'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() => _imagemPerfil = File(image.path));
                  }
                } catch (e) {
                  _mostrarErroAcesso(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarErroAcesso(String erro) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erro ao acessar mídia ou falta de permissão: $erro"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _visualizarFotoPerfil(Color corTema) {
    _vibrar();
    if (_imagemPerfil == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
          body: Center(child: Image.file(_imagemPerfil!)),
        ),
      ),
    );
  }

  void navegarParaTela(Widget tela, {bool replacement = false}) {
    _vibrar();
    if (replacement) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => tela));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_usuarioAtual == null) {
      return const Scaffold(
        body: Center(child: Text("Nenhum usuário logado.")),
      );
    }

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
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(_usuarioAtual.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Erro ao carregar os dados de perfil."));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(corTema),
                ),
              );
            }

            // ALTERAÇÃO: Puxa o nome/sobrenome da conta Google se o doc não existir no Firestore
            String nome = _usuarioAtual.displayName ?? "Sem Nome";
            String email = _usuarioAtual.email ?? "Sem Email";
            String telefone = "Não cadastrado";
            String endereco = "Não cadastrado";

            // Se o documento existe, extrai as informações atualizadas
            if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
              Map<String, dynamic> dadosDoBanco = snapshot.data!.data() as Map<String, dynamic>;
              nome = dadosDoBanco['nome'] ?? _usuarioAtual.displayName ?? "Sem Nome";
              email = dadosDoBanco['email'] ?? _usuarioAtual.email ?? "Sem Email";
              telefone = dadosDoBanco['telefone'] ?? "Não cadastrado";
              endereco = dadosDoBanco['endereco'] ?? "Não cadastrado";
            }

            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, bottom: 40),
                      decoration: BoxDecoration(
                        color: corTema,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildAvatarComFoto(corTema),
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
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: zoomInterface ? 40 : 30),
                    children: [
                      _buildInfoCard(
                        icon: Icons.phone_android_rounded,
                        title: "Telefone",
                        value: telefone,
                        corIcone: corTema,
                        paddingVertical: zoomInterface ? 20 : 12,
                      ),
                      _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        title: "Endereço",
                        value: endereco,
                        corIcone: corTema,
                        paddingVertical: zoomInterface ? 20 : 12,
                      ),
                      _buildInfoCard(
                        icon: Icons.lock_outline_rounded,
                        title: "Senha",
                        value: "********",
                        corIcone: corTema,
                        paddingVertical: zoomInterface ? 20 : 12,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _vibrar();
                            _abrirModalEdicao(context, nome, telefone, endereco, corTema);
                          },
                          icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                          label: const Text("EDITAR PERFIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corTema,
                            fixedSize: Size(double.infinity, zoomInterface ? 60 : 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            side: altoContraste ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
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
      ),
    );
  }

  void _abrirModalEdicao(BuildContext context, String nomeAtual, String telefoneAtual, String enderecoAtual, Color corTema) {
    final nomeController = TextEditingController(text: nomeAtual);
    final telefoneController = TextEditingController(text: telefoneAtual == "Não cadastrado" ? "" : telefoneAtual);
    final enderecoController = TextEditingController(text: enderecoAtual == "Não cadastrado" ? "" : enderecoAtual);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
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
                  Text("Editar Informações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corTema)),
                  const SizedBox(height: 25),
                  _buildCampoEdicao(label: "Nome Completo", controller: nomeController, icon: Icons.person, corFoco: corTema),
                  const SizedBox(height: 15),
                  _buildCampoEdicao(label: "Telefone", controller: telefoneController, icon: Icons.phone, corFoco: corTema),
                  const SizedBox(height: 15),
                  _buildCampoEdicao(label: "Endereço", controller: enderecoController, icon: Icons.map, corFoco: corTema),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            _vibrar();
                            setModalState(() => _isSaving = true);

                            try {
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(_usuarioAtual!.uid)
                                  .set({
                                    'nome': nomeController.text.trim(),
                                    'telefone': telefoneController.text.trim(),
                                    'endereco': enderecoController.text.trim(),
                                    'email': _usuarioAtual.email,
                                  }, SetOptions(merge: true));

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
                      backgroundColor: corTema,
                      minimumSize: Size(double.infinity, zoomInterface ? 65 : 55),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: altoContraste ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
          ),
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
        onTap: () {
          _vibrar();
          _fazerLogout(context);
        },
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