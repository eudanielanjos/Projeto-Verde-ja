
import 'dart:io'; // Importado para trabalhar com a classe File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importado o Image Picker
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
  // Dados simulados que podem ser alterados
  String telefone = "+55 11 99999-9999"; // Mantido com código internacional
  String endereco = "Rua Exemplo, 123";
  String bairro = "Centro"; // Nova variável para o bairro
  String nome = "Usuário Admin";

  // Variável para armazenar o arquivo da imagem selecionada
  File? _imagemPerfil;
  final ImagePicker _picker = ImagePicker();

  // Função interna para capturar do ImagePicker
  Future<void> _escolherImagem(ImageSource source) async {
    try {
      final XFile? imagemSelecionada = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Otimiza o tamanho/qualidade da imagem
        maxWidth: 500,    // Redimensiona para não sobrecarregar a memória
      );

      if (imagemSelecionada != null) {
        setState(() {
          _imagemPerfil = File(imagemSelecionada.path);
        });
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
    }
  }

  // Exibe as opções de Câmera ou Galeria ao tocar no ícone
  void _tirarFotoOuSelecionarGaleria() {
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
                leading: const Icon(Icons.camera_alt, color: Color(0xFF1F5C3A)),
                title: const Text("Tirar Foto com a Câmera"),
                onTap: () {
                  Navigator.pop(context);
                  _escolherImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Color(0xFF1F5C3A)),
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

  // Abre um modal para visualizar a foto em tamanho expandido
  void _visualizarFotoPerfil() {
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
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Icon(
                            Icons.person,
                            size: 200,
                            color: Color(0xFF1F5C3A),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      endDrawer: _buildMenuDrawer(context),
      body: Column(
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
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ],
          ),

          // --- CONTEÚDO (CARDS) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                _buildInfoCard(
                  icon: Icons.phone_android_rounded,
                  title: "Telefone (com código internacional)",
                  value: telefone,
                ),
                _buildInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "Endereço",
                  value: endereco,
                ),
                _buildInfoCard(
                  icon: Icons.holiday_village_outlined,
                  title: "Bairro",
                  value: bairro,
                ),
                _buildInfoCard(
                  icon: Icons.lock_outline_rounded,
                  title: "Senha",
                  value: "********",
                ),
                const SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirModalEdicao(context),
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
      ),
    );
  }

  void _abrirModalEdicao(BuildContext context) {
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
              const Text("Editar Informações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F5C3A))),
              const SizedBox(height: 25),
              _buildCampoEdicao(label: "Telefone (Obrigatório Ex: +55...)", controller: telefoneController, icon: Icons.phone),
              const SizedBox(height: 15),
              _buildCampoEdicao(label: "Endereço", controller: enderecoController, icon: Icons.map),
              const SizedBox(height: 15),
              _buildCampoEdicao(label: "Bairro", controller: bairroController, icon: Icons.holiday_village_outlined),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String textoTelefone = telefoneController.text.trim();

                  // Validação: Verifica se começa estritamente com '+' seguido de números (Ex: +55...)
                  RegExp ddiRegex = RegExp(r'^\+\d+');

                  if (!ddiRegex.hasMatch(textoTelefone)) {
                    // Exibe um aviso caso o DDI não tenha sido informado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erro: O código internacional (Ex: +55) é obrigatório!"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return; // Bloqueia a execução e não fecha o modal
                  }

                  setState(() {
                    telefone = textoTelefone;
                    endereco = enderecoController.text;
                    bairro = bairroController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5C3A),
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

  // --- EXIBIÇÃO DE FOTO DINÂMICA COM SUPORTE A TOQUE ---
  Widget _buildAvatarComFoto() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: _visualizarFotoPerfil, // Abre a visualização ampliada ao tocar na foto
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFFF1F5F2),
              backgroundImage: _imagemPerfil != null ? FileImage(_imagemPerfil!) : null,
              child: _imagemPerfil == null
                  ? const Icon(Icons.person, size: 65, color: Color(0xFF1F5C3A))
                  : null,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _tirarFotoOuSelecionarGaleria, // Abre as opções de escolha de foto
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF1F5C3A),
                child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoEdicao({required String label, required TextEditingController controller, required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1F5C3A)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF1F5C3A)), borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F2), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: const Color(0xFF1F5C3A)),
        ),
        title: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF2D312E), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMenuDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
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
                _buildMenuCard(icon: Icons.home, title: "Início", onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                }),
                _buildMenuCard(icon: Icons.calendar_today, title: "Coleta Regular", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaView()));
                }),
                _buildMenuCard(icon: Icons.school, title: "Educação", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                }),
                _buildMenuCard(icon: Icons.person, title: "Perfil", onTap: () => Navigator.pop(context)),
                _buildMenuCard(icon: Icons.history, title: "Histórico de Denúncias", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
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
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF1F5C3A)),
            title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSairButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false),
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

