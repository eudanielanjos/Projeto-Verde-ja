import 'dart:async';
import 'package:flutter/material.dart';
import 'home_view.dart';
class SplashViewCadastro extends StatefulWidget {
  const SplashViewCadastro({super.key});
@override
  State<SplashViewCadastro> createState() => _SplashViewCadastro();
}

class _SplashViewCadastro extends State<SplashViewCadastro>
  with SingleTickerProviderStateMixin{
    late AnimationController _controller;

    @override
    void initState(){
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
        );
      _controller.forward();
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
        MaterialPageRoute(builder: (_) => const HomeView()),  
        );
      });
    } 
    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.25, 0.6], // controla onde o verde para
    colors: [
      Color(0xFF5FAF7A), // verde mais suave (topo)
      Color(0xFFEFF5F1), // transição bem clara
      Colors.white,      // resto branco
    ],
  ),
),
          child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Spacer(),

    Image.asset(
      'assets/images/logo3.png',
      width: 250,
    ),

    const SizedBox(height: 20),

    SizedBox(
  width: 215,
  height: 10,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: Curves.easeInOut.transform(_controller.value), // animação suave
            minHeight: 10,
            backgroundColor: const Color(0xFFE6EFE9), // trilho claro
            valueColor: AlwaysStoppedAnimation(
              const Color.fromARGB(255, 81, 146, 72), // verde moderno
            ),
          );
        },
      ),
    ),
  ),
),

    const SizedBox(height: 40),

    // 🔥 MENSAGEM
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'Cadastro finalizado com sucesso',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),

    const SizedBox(height: 40),

    // 🔥 BOTÃO
    /*Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Continuar',
          style: TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
        )
      ],
    ),*/

    const Spacer(),
  ],
),
        )
      );
    }
  }