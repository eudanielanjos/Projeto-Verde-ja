import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. IMPORTADO O FIRESTORE
import 'tela_inicial_view.dart'; 

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
  final TextEditingController _confirmarSenhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _isLoading = false;
  bool _autoValidate = false;
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

  void _mostrarSplashSucesso() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TelaInicialView()),
                (route) => false,
              );
            }
          });

          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5E7F6B), Color(0xFFF2F2F2), Color(0xFFF2F2F2)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF305D3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Cadastro Concluído!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF305D3C),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Sua conta foi criada com sucesso.\nPreparando seu ambiente...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7BB132)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔥 ALTERADO: FUNÇÃO DE CADASTRO SALVANDO NO AUTH E NO FIRESTORE
  Future<void> _cadastrar() async {
    setState(() => _autoValidate = true);
    if (!_formKey.currentState!.validate()) return;

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Cria o usuário no Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // 2. Garante que o usuário foi criado para rodar os próximos passos
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Atualiza o DisplayName nativo do Auth (bom ter por garantia)
        await userCredential.user!.updateDisplayName(_nomeController.text.trim());

        // 3. SALVA OS DADOS COMPLEMENTARES NO FIRESTORE
        // Cria um documento dentro de 'usuarios' onde o ID do documento é o próprio UID do Auth
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'uid': uid,
          'nome': _nomeController.text.trim(),
          'email': _emailController.text.trim(),
          'criadoEm': FieldValue.serverTimestamp(), // Guarda a data/hora exata do servidor do Firebase
          'ativo': true, // Exemplo de metadado útil
        });
      }

      if (!mounted) return;

      // 4. CHAMA O SPLASH DE SUCESSO COORDENADO
      _mostrarSplashSucesso();

    } on FirebaseAuthException catch (e) {
      String mensagemErro = "Ocorreu um erro.";
      if (e.code == 'weak-password') {
        mensagemErro = "A senha fornecida é muito fraca.";
      } else if (e.code == 'email-already-in-use') {
        mensagemErro = "Este e-mail já está cadastrado.";
      } else if (e.code == 'invalid-email') {
        mensagemErro = "O formato do e-mail é inválido.";
      } else if (e.message != null) {
        mensagemErro = e.message!;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red)
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar dados: ${e.toString()}"), backgroundColor: Colors.red)
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            colors: [Color(0xFF5E7F6B), Color(0xFFF2F2F2), Color(0xFFF2F2F2)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Image.asset("assets/images/logo.png", height: 165, errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, size: 100, color: Color(0xFF305D3C))),
                      const SizedBox(height: 10),
                      const Text(
                        'Viva verde, viva melhor!',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromRGBO(48, 93, 60, 1),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      _buildInput('Nome Completo', controller: _nomeController),
                      const SizedBox(height: 20),
                      _buildInput('Email', controller: _emailController),
                      const SizedBox(height: 20),
                      _buildInput(
                        'Senha',
                        controller: _senhaController,
                        obscure: !_senhaVisivel,
                        onChanged: _verificarForcaSenha,
                        icon: IconButton(
                          icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        'Confirmar Senha',
                        controller: _confirmarSenhaController,
                        obscure: !_confirmarSenhaVisivel,
                        icon: IconButton(
                          icon: Icon(_confirmarSenhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7BB132),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _cadastrar,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Cadastrar', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Já possui conta? ', style: TextStyle(color: Colors.black, fontSize: 19)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text(
                              'Faça login',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF305D3C), fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, {bool obscure = false, required TextEditingController controller, Widget? icon, Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) return "Preencha $hint";
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF5F826C),
        suffixIcon: icon,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}