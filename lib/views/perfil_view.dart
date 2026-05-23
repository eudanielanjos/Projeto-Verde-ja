import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

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
  // --- DADOS SIMULADOS ---
  String telefone = "+55 11 99999-9999";
  String endereco = "Rua Exemplo, 123";
  String bairro = "Centro";
  String nome = "Usuário Admin";

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
  void initState() {
    super.initState();
    carregarAcessibilidade();
  }

  // Carrega as configurações guardadas no dispositivo
  Future<void> carregarAcessibilidade() async {
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

  // Lógica de vibração baseada nas preferências do usuário
  void vibrar() async {
    if (vibracao) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }
    }
  }

  // Intercepta a navegação para atualizar o visual quando o usuário retorna
  void navegarParaTela(Widget tela, {bool replacement = false}) async {
    vibrar();
    if (replacement) {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => tela));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
    }
    carregarAcessibilidade();
  }

  Future<void> _escolherImagem(ImageSource source) async {
    try {
      final XFile? imagemSelecionada = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 500,
      );

      if (imagemSelecionada != null) {
        setState(() {
          _imagemPerfil = File(imagemSelecionada.path);
        });
        vibrar();
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
    }
  }

  void _tirarFotoOuSelecionarGaleria(Color corTema) {
    vibrar();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Foto de Perfil",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: corTema),
                title: const Text("Tirar Foto com a Câmera"),
                onTap: () {
                  Navigator.pop(context);
                  _escolherImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image, color: corTema),
                title: const Text("Escolher da Galeria"),
                onTap: () {
                  Navigator.pop(context);
                  _escolherImagem(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _visualizarFotoPerfil(Color corTema) {
    vibrar();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  color: const Color(0xFFF1F5F2),
                  child: _imagemPerfil != null
                      ? Image.file(
                          _imagemPerfil!,
                          fit: BoxFit.contain,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Icon(
                            Icons.person,
                            size: 200,
                            color: corTema,
                          ),
                        ),
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
    // --- TEMAS ADAPTATIVOS DE COR ---
    Color corTema;
    if (altoContraste) {
      corTema = Colors.black;
    } else if (daltonismo) {
      corTema = const Color(0xFF455A64);
    } else {
      corTema = const Color(0xFF1F5C3A);
    }

    // --- SE ADAPTANDO AO ZOOM DE INTERFACE ---
    double paddingVerticalCard = zoomInterface ? 16 : 8;
    double alturaBotaoEditar = zoomInterface ? 60 : 50;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(escalaFonte),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        endDrawer: _buildMenuDrawer(context, corTema),
        body: Column(
          children: [
            // --- HEADER CURVADO ---
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
                      ),
                      const Text(
                        "admin123@email.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
                        vibrar();
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ),
              ],
            ),

            // --- LISTA DE INFORMAÇÕES DO PERFIL ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  _buildInfoCard(
                    icon: Icons.phone_android_rounded,
                    title: "Telefone (com código internacional)",
                    value: telefone,
                    corIcone: corTema,
                    paddingVertical: paddingVerticalCard,
                  ),
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: "Endereço",
                    value: endereco,
                    corIcone: corTema,
                    paddingVertical: paddingVerticalCard,
                  ),
                  _buildInfoCard(
                    icon: Icons.holiday_village_outlined,
                    title: "Bairro",
                    value: bairro,
                    corIcone: corTema,
                    paddingVertical: paddingVerticalCard,
                  ),
                  _buildInfoCard(
                    icon: Icons.lock_outline_rounded,
                    title: "Senha",
                    value: "********",
                    corIcone: corTema,
                    paddingVertical: paddingVerticalCard,
                  ),
                  const SizedBox(height: 20),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirModalEdicao(context, corTema),
                      icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                      label: const Text("EDITAR PERFIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corTema,
                        fixedSize: Size(double.infinity, alturaBotaoEditar),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: altoContraste ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirModalEdicao(BuildContext context, Color corTema) {
    vibrar();
    final telefoneController = TextEditingController(text: telefone);
    final enderecoController = TextEditingController(text: endereco);
    final bairroController = TextEditingController(text: bairro);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
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
              _buildCampoEdicao(label: "Telefone (Obrigatório Ex: +55...)", controller: telefoneController, icon: Icons.phone, corFoco: corTema),
              const SizedBox(height: 15),
              _buildCampoEdicao(label: "Endereço", controller: enderecoController, icon: Icons.map, corFoco: corTema),
              const SizedBox(height: 15),
              _buildCampoEdicao(label: "Bairro", controller: bairroController, icon: Icons.holiday_village_outlined, corFoco: corTema),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  vibrar();
                  String textoTelefone = telefoneController.text.trim();
                  RegExp ddiRegex = RegExp(r'^\+\d+');

                  if (!ddiRegex.hasMatch(textoTelefone)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erro: O código internacional (Ex: +55) é obrigatório!"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    telefone = textoTelefone;
                    endereco = enderecoController.text;
                    bairro = bairroController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTema,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("SALVAR ALTERAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
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
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Olá, Usuario", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
        onTap: () {
          vibrar();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
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