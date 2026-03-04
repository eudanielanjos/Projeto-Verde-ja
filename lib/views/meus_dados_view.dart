import 'package:flutter/material.dart';

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

  void salvarDados() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dados salvos com sucesso!"),
        backgroundColor: Color(0xFF1F5C3A),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pop(context);
    });
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
                Color(0xFF6F8F7C),
                Color(0xFFEDEDED),
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
                      onPressed: salvarDados,
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

  Widget _buildField(String titulo, String valor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF5E7F6B),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              valor.isEmpty ? titulo : valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}