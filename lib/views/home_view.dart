import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'tela_inicial_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _fazerLoginGoogle(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final AuthService authService = AuthService();

    try {
      final user = await authService.signInWithGoogle();
      
      if (user != null) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const TelaInicialView()),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com Google: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com Gradiente
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

          // Conteúdo Principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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

                    // Botão Google
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

                    // Rodapé: Ir para Login tradicional
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
            ),
          ),
        ],
      ),
    );
  }
}