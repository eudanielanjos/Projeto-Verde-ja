import 'package:flutter/material.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🔹 FUNDO LIMPO (SEM NEBLINA)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF5E7F6B),
                  Color(0xFFE6E6E6),
                ],
              ),
            ),
          ),

          // 🔹 BOTÃO VOLTAR
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

                    // 🔹 LOGO PNG
                    Image.asset(
                      "assets/images/logo.png",
                      height: 160,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Viva verde, viva melhor!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    _buildInput(
                      'Email',
                      controller: _emailController,
                    ),

                    const SizedBox(height: 15),

                    _buildInput(
                      'Senha',
                      controller: _senhaController,
                      obscure: true,
                    ),

                    const SizedBox(height: 25),

                    // 🔹 BOTÃO ENTRAR
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BB132),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacementNamed(
                                context, '/home');
                          }
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 IR PARA CADASTRO
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Não possui conta? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/cadastro');
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF305D3C),
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

  Widget _buildInput(String hint,
      {bool obscure = false,
      required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Preencha $hint";
        }
        if (hint == "Email" && !value.contains("@")) {
          return "Email inválido";
        }
        if (hint == "Senha" && value.length < 6) {
          return "Mínimo 6 caracteres";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        hintStyle:
            const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}