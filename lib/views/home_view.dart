import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart'; 
import 'tela_inicial_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _fazerLoginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaInicialView()),
        );
      }
    } catch (e) {
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
          // Fundo
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

          // Conteúdo
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
                const SizedBox(height: 40),

                // Botão Cadastrar
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

                const SizedBox(height: 15),

                // Botão Visitante
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

                const SizedBox(height: 25),
                const Text('Ou acesse com', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
                const SizedBox(height: 15),

                // 🔥 BOTÃO GOOGLE (ESTILO LARGO)
                SizedBox(
                  width: 310,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: Image.asset('assets/images/google.png', width: 24),
                    label: const Text('Entrar com Google', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    onPressed: () => _fazerLoginGoogle(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

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

        ],
      ),
    );
  }
}