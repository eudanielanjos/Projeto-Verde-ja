import 'package:flutter/material.dart';

class CadastroView extends StatelessWidget {
  const CadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: // CONTEÚDO PRINCIPAL
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone e título
                    Image.asset(
                  "assets/images/logo.png",
                  height: 130,
                  ),
 

                    const SizedBox(height: 10),

                    const Text(
                      'VerdeJá',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(132, 27, 94, 31),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Viva verde, viva melhor!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Campo Nome
                    _buildInput('Nome Completo'),

                    const SizedBox(height: 10),

                    // Campo Email
                    _buildInput('Email'),

                    const SizedBox(height: 10),

                    // Campo Senha
                    _buildInput('Senha', obscure: true),

                    const SizedBox(height: 10),

                    // Confirmar Senha
                    _buildInput('Confirmar Senha', obscure: true),

                    const SizedBox(height: 20),

                    // Botão
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
                          print('Cadastrar pressionado');
                        },
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Já possui conta
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Já possui conta? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Faça login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
      );
  }

  // Widget reutilizável para campos de texto
  static Widget _buildInput(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        hintStyle: const TextStyle(color: Color(0xECFFFFFF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}