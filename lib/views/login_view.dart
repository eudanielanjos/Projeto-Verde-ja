import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com Gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF5E7F6B), Color(0xFFF2F2F2), Color(0xFFF2F2F2)],
              ),
            ),
          ),
          
          // Botão de Voltar
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset("assets/images/logo.png", height: 160),
                    const SizedBox(height: 10),
                    const Text(
                      'Viva verde, viva melhor!',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 50),

                    _buildInput('Email', controller: _emailController),
                    const SizedBox(height: 15),
                    _buildInput('Senha', controller: _senhaController, obscure: true),
                    
                    const SizedBox(height: 30),

                    // Botão Entrar com Lógica de Admin
                    _isLoading 
                      ? const CircularProgressIndicator(color: Color(0xFF7BB132))
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7BB132),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String email = _emailController.text.trim().toLowerCase();
                                String senha = _senhaController.text;

                                // LÓGICA DE FILTRO DE USUÁRIO
                                if (email == 'admin@verdeja.com' && senha == 'admin123') {
                                  Navigator.pushReplacementNamed(context, '/admin');
                                } else {
                                  // Aqui entraria sua lógica de login real via AuthService
                                  Navigator.pushReplacementNamed(context, '/inicial');
                                }
                              }
                            },
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                    const SizedBox(height: 15),

                    // Botão Google
                    OutlinedButton.icon(
                      icon: Image.asset('assets/images/google.png', height: 24),
                      label: const Text(
                        'Entrar com Google', 
                        style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : () async {
                        setState(() => _isLoading = true);
                        try {
                          final user = await _authService.signInWithGoogle();
                          if (user != null && mounted) {
                            Navigator.pushReplacementNamed(context, '/inicial');
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao entrar: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    // Rodapé
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não possui conta? ', style: TextStyle(color: Colors.black, fontSize: 16)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/cadastro'),
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFF305D3C), 
                              fontSize: 16,
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
        ],
      ),
    );
  }

  Widget _buildInput(String hint, {bool obscure = false, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) => (value == null || value.isEmpty) ? "Preencha $hint" : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        hintStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}