import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import necessário
import 'package:google_sign_in/google_sign_in.dart'; // Import necessário
import 'tela_inicial_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // 🔹 FUNÇÃO QUE ABRE O LOGIN DO GOOGLE
  Future<void> _fazerLoginGoogle(BuildContext context) async {
    try {
      // 1. Abre a janelinha do Google para selecionar o e-mail
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Usuário fechou a janelinha

      // 2. Obtém os dados de autenticação da conta selecionada
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz o login no Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 5. Se deu certo, vai para a tela inicial
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaInicialView()),
        );
      }
    } catch (e) {
      // Exibe erro caso algo falhe (ex: falta de internet ou erro de config)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao conectar com Google: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo (Mantido)
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

          // Conteúdo (Mantido)
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 190),
                const SizedBox(height: 10),
                const Text(
                  'Seja bem-vindo!',
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(48, 93, 60, 1),
                  ),
                ),
                const SizedBox(height: 50),

                // Botão Cadastrar (Mantido)
                SizedBox(
                  width: 310,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(99, 134, 108, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cadastrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  ),
                ),

                const SizedBox(height: 25),

                // Botão Visitante (Mantido)
                SizedBox(
                  width: 310,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaInicialView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(99, 134, 108, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Acessar como visitante', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Acessar com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/facebook.png', width: 40),
                      onPressed: () {}, 
                    ),
                    // 🔥 AQUI ESTÁ A CHAMADA PARA O LOGIN DO GOOGLE
                    IconButton(
                      icon: Image.asset('assets/images/google.png', width: 40),
                      onPressed: () => _fazerLoginGoogle(context), 
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui conta?', style: TextStyle(fontSize: 19)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Faça login',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Imagem Base (Mantida)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/base.png', width: double.infinity, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}