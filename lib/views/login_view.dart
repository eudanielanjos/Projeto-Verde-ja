import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // Função para lidar com o login do Google
  Future<void> _signInWithGoogle() async {
    try {
      // Inicia o fluxo de autenticação do Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtém os detalhes de autenticação da requisição
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Cria uma nova credencial para o Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Faz o login no Firebase com a credencial do Google
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Se tudo der certo, vai para a Home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      // Aqui você pode mostrar um SnackBar com o erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao entrar com Google: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF5E7F6B), Color(0xFFF2F2F2), Color(0xFFF2F2F2)],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset("assets/images/logo.png", height: 160),
                    const SizedBox(height: 10),
                    const Text('Viva verde, viva melhor!', style: TextStyle(fontSize: 18, color: Colors.black54)),
                    const SizedBox(height: 70),
                    _buildInput('Email', controller: _emailController),
                    const SizedBox(height: 20),
                    _buildInput('Senha', controller: _senhaController, obscure: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Esqueci minha senha", style: TextStyle(color: Color(0xFF305D3C), fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // BOTÃO ENTRAR COM LÓGICA DE CREDENCIAIS
                    SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BB132),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String email = _emailController.text.trim();
                            String senha = _senhaController.text.trim();

                            if (email == "admin@verdeja.com" && senha == "admin123") {
                              Navigator.pushReplacementNamed(context, '/admin');
                            } else {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          }
                        },
                        child: const Text('Entrar', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // BOTÃO GOOGLE
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(220, 50),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      ),
                      onPressed: _signInWithGoogle,
                      icon: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                        height: 24,
                      ),
                      label: const Text(
                        "Entrar com Google",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não possui conta? ', style: TextStyle(color: Colors.black, fontSize: 18)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/cadastro'),
                          child: const Text('Cadastre-se', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF305D3C), fontSize: 19)),
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

  Widget _buildInput(String hint, {bool obscure = false, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) return "Preencha $hint";
        if (hint == "Email" && !value.contains("@")) return "Email inválido";
        if (hint == "Senha" && value.length < 6) return "Mínimo 6 caracteres";
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}