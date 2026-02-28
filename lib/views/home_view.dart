import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🔹 Fundo com gradiente
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

          // 🔹 Conteúdo principal
          Padding(
            padding: const EdgeInsets.only(bottom: 120), // espaço para a onda
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Seja bem-vindo!',
                  style: TextStyle(
                    fontSize: 35,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(48, 93, 60, 1),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 310,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(99, 134, 108, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 310,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(99, 134, 108, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Acessar como visitante',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Acessar com',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/facebook.png',
                        width: 40,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/google.png',
                        width: 40,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já possui conta?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {},
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}