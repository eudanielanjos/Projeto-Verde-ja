
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeusDadosView extends StatefulWidget {
  const MeusDadosView({super.key});

  @override
  State<MeusDadosView> createState() => _MeusDadosViewState();
}

class _MeusDadosViewState extends State<MeusDadosView> {
  String nome = "";
  String telefone = "";
  String email = "";
  String estado = "";

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  /// 🔹 Carregar dados
  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nome = prefs.getString('nome') ?? "";
      telefone = prefs.getString('telefone') ?? "";
      email = prefs.getString('email') ?? "";
      estado = prefs.getString('estado') ?? "";
    });
  }

  /// 🔹 Salvar dados
  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nome', nome);
    await prefs.setString('telefone', telefone);
    await prefs.setString('email', email);
    await prefs.setString('estado', estado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dados salvos com sucesso"),
        backgroundColor: Color(0xFF1F5C3A),
      ),
    );
  }

  /// 🔹 Editar campo
  Future<void> editarCampo(
      String titulo,
      String valorAtual,
      TextInputType teclado,
      Function(String) onSalvar) async {

    final controller = TextEditingController(text: valorAtual);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $titulo"),
        content: TextField(
          controller: controller,
          keyboardType: teclado,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
              _salvarDados();
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

    return Scaffold(
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

              /// 🔹 Topo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),

                    const Icon(Icons.settings)
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 FOTO PERFIL
              Stack(
                children: [

                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF1F5C3A),
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F5C3A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
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

              /// 🔹 CAMPOS
              _campo("Nome", nome, Icons.person, () {
                editarCampo(
                  "Nome",
                  nome,
                  TextInputType.name,
                      (v) => setState(() => nome = v),
                );
              }),

              _campo("Telefone", telefone, Icons.phone, () {
                editarCampo(
                  "Telefone",
                  telefone,
                  TextInputType.phone,
                      (v) => setState(() => telefone = v),
                );
              }),

              _campo("Email", email, Icons.email, () {
                editarCampo(
                  "Email",
                  email,
                  TextInputType.emailAddress,
                      (v) => setState(() => email = v),
                );
              }),

              _campo("Estado", estado, Icons.location_on, () {
                editarCampo(
                  "Estado",
                  estado,
                  TextInputType.text,
                      (v) => setState(() => estado = v),
                );
              }),

              const Spacer(),

              /// 🔹 BOTÃO SALVAR
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 70),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await _salvarDados();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Widget campo
  Widget _campo(String titulo, String valor, IconData icon, VoidCallback onTap) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 60,

          padding: const EdgeInsets.symmetric(horizontal: 15),

          decoration: BoxDecoration(
            color: const Color(0xFF5E7F6B),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Row(
            children: [

              Icon(icon, color: Colors.white),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  valor.isEmpty ? titulo : valor,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 19,
                  ),
                ),
              ),

              const Icon(
                Icons.edit,
                color: Colors.white70,
              )
            ],
          ),
        ),
      ),
    );
  }
}