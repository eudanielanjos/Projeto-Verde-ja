import 'package:flutter/material.dart';
import 'home_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;
  bool _senhaVisivel = false;

  void _mostrarAviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _login() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarAviso("Preencha todos os campos");
      return;
    }

    if (!email.contains("@")) {
      _mostrarAviso("Digite um email válido");
      return;
    }

    if (senha.length < 6) {
      _mostrarAviso("A senha deve ter no mínimo 6 caracteres");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (email == "admin@email.com" && senha == "123456") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _mostrarAviso("Email ou senha incorretos");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🔹 FUNDO IGUAL À TELA INICIAL
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(99, 134, 108, 1),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 CONTEÚDO
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [

                        const SizedBox(height: 60),

                        // 🔹 BOTÃO VOLTAR
                        Align(
                          alignment: Alignment.centerLeft,
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
                                  builder: (context) =>
                                      const HomeView(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Image.asset(
                          'assets/images/logo.png',
                          height: 120,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Viva verde, viva melhor!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: Color.fromRGBO(48, 93, 60, 1),
                          ),
                        ),

                        const SizedBox(height: 50),

                        _buildEmailField(),
                        const SizedBox(height: 12),
                        _buildSenhaField(),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(99, 134, 108, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                                _isLoading ? null : _login,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Acessar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ainda não possui conta? ',
                              style: TextStyle(
                                  color: Colors.black87),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/cadastro');
                              },
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Color.fromRGBO(
                                      48, 93, 60, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(99, 134, 108, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _emailController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.white70),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSenhaField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(99, 134, 108, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _senhaController,
        obscureText: !_senhaVisivel,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Senha",
          hintStyle:
              const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _senhaVisivel
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _senhaVisivel = !_senhaVisivel;
              });
            },
          ),
        ),
      ),
    );
  }
}