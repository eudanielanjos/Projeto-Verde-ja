import 'package:flutter/material.dart';

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
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E7F6B),
              Color(0xFFEAEAEA),
              Color(0xFFEAEAEA),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('assets/images/logo.png', height: 120),
                    const SizedBox(height: 12),
                    const Text(
                      'Viva verde, viva melhor!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF1F5C3A),
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
                          backgroundColor: const Color(0xFF1F5C3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Acessar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ainda não possui conta? ',
                          style: TextStyle(color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/cadastro');
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F5C3A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF5E7F6B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _emailController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.white70),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSenhaField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF5E7F6B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _senhaController,
        obscureText: !_senhaVisivel,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Senha",
          hintStyle: const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _senhaVisivel ? Icons.visibility : Icons.visibility_off,
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFF1F5C3A),
      ),
      body: const Center(
        child: Text(
          "Login realizado com sucesso!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}