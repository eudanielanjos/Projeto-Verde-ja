import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeusDadosView extends StatefulWidget {
  const MeusDadosView({super.key});

  @override
  State<MeusDadosView> createState() => _MeusDadosViewState();
}

class _MeusDadosViewState extends State<MeusDadosView> {
  String nome = "Nome:";
  String telefone = "Telefone:";
  String email = "Email:";
  String estado = "Estado:";

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // 🔹 Carregar dados salvos
  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('nome') ?? "Nome:";
      telefone = prefs.getString('telefone') ?? "Telefone:";
      email = prefs.getString('email') ?? "Email:";
      estado = prefs.getString('estado') ?? "Estado:";
    });
  }

  // 🔹 Salvar dados no SharedPreferences
  Future<void> _salvarDadosLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setString('telefone', telefone);
    await prefs.setString('email', email);
    await prefs.setString('estado', estado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dados salvos com sucesso!"),
        backgroundColor: Color(0xFF1F5C3A),
      ),
    );
  }

  // 🔹 Função genérica para editar qualquer campo
  Future<void> editarCampo(
      String titulo, String valorAtual, Function(String) onSalvar) async {
    final controller = TextEditingController(text: valorAtual);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $titulo"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Digite $titulo",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F5C3A),
            ),
            onPressed: () {
              onSalvar(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5E7F6B),
                Color(0xFFF2F2F2),
                Color(0xFFF2F2F2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.black54),
                      ),
                      const Icon(Icons.menu, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF1F5C3A),
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "MEUS DADOS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F5C3A),
                  ),
                ),
                const SizedBox(height: 30),

                // 🔹 Campos clicáveis
                _buildField("Nome", nome, () {
                  editarCampo("Nome", nome, (novoValor) {
                    setState(() => nome = novoValor);
                  });
                }),
                _buildField("Telefone", telefone, () {
                  editarCampo("Telefone", telefone, (novoValor) {
                    setState(() => telefone = novoValor);
                  });
                }),
                _buildField("Email", email, () {
                  editarCampo("Email", email, (novoValor) {
                    setState(() => email = novoValor);
                  });
                }),
                _buildField("Estado", estado, () {
                  editarCampo("Estado", estado, (novoValor) {
                    setState(() => estado = novoValor);
                  });
                }),

                const Spacer(),

                /// 🔥 BOTÃO SALVAR
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F5C3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await _salvarDadosLocal();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Salvar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Campo clicável
  Widget _buildField(String titulo, String valor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap, // clicando direto no campo
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF5E7F6B),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            valor.isEmpty ? titulo : valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}