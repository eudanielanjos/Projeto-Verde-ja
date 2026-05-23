import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. IMPORTADO O FIRESTORE
import 'package:firebase_auth/firebase_auth.dart'; // Importado para capturar erros específicos

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

  // Método para processar login por email/senha integrado ao Firestore
  Future<void> _fazerLoginEmailSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String email = _emailController.text.trim().toLowerCase();
    String senha = _senhaController.text;

    try {
      // Filtro para conta Administrador estática
      if (email == 'admin@verdeja.com' && senha == 'admin123') {
        navigator.pushReplacementNamed('/admin');
        return;
      }

      // 1. Faz o login real usando o seu serviço do Firebase Auth
      final user = await _authService.signInWithEmail(email, senha);
      
      if (user != null) {
        // 2. BUSCA AS INFORMAÇÕES DO DOCUMENTO DELE NO FIRESTORE
        DocumentSnapshot docUsuario = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        if (docUsuario.exists) {
          Map<String, dynamic> dadosDoUsuario = docUsuario.data() as Map<String, dynamic>;
          
          bool estaAtivo = dadosDoUsuario['ativo'] ?? true;
          String nomeDoUsuario = dadosDoUsuario['nome'] ?? 'Usuário';

          // Validação de segurança opcional: Conta desativada
          if (!estaAtivo) {
            await FirebaseAuth.instance.signOut(); // Desconecta a sessão forçadamente
            throw 'Esta conta foi desativada temporariamente.';
          }

          // Snack-bar amigável de boas-vindas
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Bem-vindo de volta, $nomeDoUsuario!'),
              backgroundColor: const Color(0xFF305D3C),
            ),
          );
        }

        if (mounted) {
          navigator.pushReplacementNamed('/inicial');
        }
      }
    } on FirebaseAuthException catch (e) {
      // Captura erros específicos de credenciais do Firebase
      String erroMsg = 'Erro ao autenticar.';
      if (e.code == 'invalid-credential' || e.code == 'wrong-password' || e.code == 'user-not-found') {
        erroMsg = 'E-mail ou senha incorretos.';
      } else {
        erroMsg = e.message ?? erroMsg;
      }
      
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(erroMsg), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Método para processar login com Google nesta tela
  Future<void> _fazerLoginGoogle() async {
    setState(() => _isLoading = true);
    
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        // Se o usuário logou com o Google, criamos ou checamos o registro dele no Firestore
        final docRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
        final docSnap = await docRef.get();

        // Se for o primeiro login do Google dele no app, cria o doc básico para não dar erro no Perfil
        if (!docSnap.exists) {
          await docRef.set({
            'uid': user.uid,
            'nome': user.displayName ?? 'Usuário Google',
            'email': user.email,
            'ativo': true,
            'criadoEm': FieldValue.serverTimestamp(),
          });
        }

        if (mounted) {
          navigator.pushReplacementNamed('/inicial');
        }
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao entrar com Google: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
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
                    Image.asset("assets/images/logo.png", height: 165, errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, size: 100, color: Color(0xFF305D3C))),
                    const SizedBox(height: 10),
                    const Text(
                      'Viva verde, viva melhor!',
                      style: TextStyle(
                        fontSize: 30, 
                        color: Color.fromRGBO(48, 93, 60, 1), 
                        fontStyle: FontStyle.italic, 
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 50),

                    _buildInput('Email', controller: _emailController),
                    const SizedBox(height: 15),
                    _buildInput('Senha', controller: _senhaController, obscure: true),
                    
                    const SizedBox(height: 30),

                    // Botão Entrar ou Indicador de Carregamento
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
                              onPressed: _fazerLoginEmailSenha,
                              child: const Text(
                                'Entrar',
                                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                    const SizedBox(height: 15),

                    // Botão Google
                    OutlinedButton.icon(
                      icon: Image.asset('assets/images/google.png', height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata)),
                      label: const Text(
                        'Entrar com Google', 
                        style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600)
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _fazerLoginGoogle,
                    ),

                    const SizedBox(height: 40),

                    // Rodapé
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não possui conta? ', style: TextStyle(color: Colors.black, fontSize: 20)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/cadastro'),
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFF305D3C), 
                              fontSize: 20,
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