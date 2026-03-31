import 'package:flutter/material.dart';
import 'home_view.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  String _forcaSenha = "";

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _verificarForcaSenha(String senha) {
    if (senha.length < 6) {
      setState(() => _forcaSenha = "Senha fraca");
    } else if (senha.length < 8) {
      setState(() => _forcaSenha = "Senha média");
    } else {
      setState(() => _forcaSenha = "Senha forte");
    }
  }

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("As senhas não coincidem"),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso! 🎉"),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🔹 FUNDO
          Container(
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
          ),

          // 🔹 VOLTAR
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                );
              },
            ),
          ),

          // 🔹 CONTEÚDO
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    const SizedBox(height: 80),

                    Image.asset(
                      "assets/images/logo.png",
                      height: 190,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Viva verde, viva melhor!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 50),

                    _buildInput(
                      'Nome Completo',
                      controller: _nomeController,
                    ),

                      const SizedBox(height: 20),

                    _buildInput(
                      'Email',
                      controller: _emailController,
                    ),

                    const SizedBox(height: 20),

                    _buildInput(
                      'Senha',
                      controller: _senhaController,
                      obscure: !_senhaVisivel,
                      icon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _senhaVisivel = !_senhaVisivel;
                          });
                        },
                      ),
                      onChanged: _verificarForcaSenha,
                    ),

                    if (_forcaSenha.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _forcaSenha,
                          style: TextStyle(
                            color: _forcaSenha == "Senha forte"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    _buildInput(
                      'Confirmar Senha',
                      controller: _confirmarSenhaController,
                      obscure: !_confirmarSenhaVisivel,
                      icon: IconButton(
                        icon: Icon(
                          _confirmarSenhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmarSenhaVisivel =
                                !_confirmarSenhaVisivel;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BB132),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        onPressed: _cadastrar,
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Já possui conta? ',
                          style: TextStyle(color: Colors.black,
                            fontSize: 18
                            
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/login');
                          },
                          child: const Text(
                            'Faça login',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(48, 93, 60, 1),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    String hint, {
    bool obscure = false,
    required TextEditingController controller,
    Widget? icon,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Preencha $hint";
        }

        if (hint == "Email") {
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return "Email inválido";
          }
        }

        if (hint == "Senha") {
          if (value.length < 6) {
            return "Mínimo 6 caracteres";
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        suffixIcon: icon,
        hintStyle: const TextStyle(color: Color(0xECFFFFFF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}