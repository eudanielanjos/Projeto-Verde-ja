import 'package:flutter/material.dart';
import 'tela_inicial_view.dart';

class CadastroConcluidoView extends StatelessWidget {
  const CadastroConcluidoView({super.key});

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
            colors: [Color.fromRGBO(120, 159, 130, 1), Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de Sucesso com um círculo de fundo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F5C3A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              
              // Título de sucesso
              const Text(
                "Cadastro Concluído!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              
              // Subtítulo descritivo
              const Text(
                "Sua conta foi criada com sucesso. Seja bem-vindo ao VerdeJá e comece a fazer a diferença!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              // Botão para ir para a Home (no padrão do seu botão de cadastrar)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7BB132), // O verde claro do seu botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    // Limpa o histórico e vai para a Tela Inicial definitiva
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaInicialView()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Começar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}