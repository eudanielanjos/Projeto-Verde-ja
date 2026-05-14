import 'dart:async';
import 'package:flutter/material.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _contentOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Aumentado para fluidez
    );

    // Entrada suave do logo
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // Efeito "Pop" elástico no logo
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.6, curve: Curves.elasticOut),
    );

    // Texto e barra aparecem com atraso elegante
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
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
            colors: [
              Color.fromARGB(255, 30, 146, 65),
              Color.fromARGB(255, 247, 247, 247),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO ANIMADO COM SOMBRA SUTIL
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo3.png',
                    width: 240,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),

            // GRUPO DE CARREGAMENTO
            FadeTransition(
              opacity: _contentOpacity,
              child: Column(
                children: [
                  // Texto com espaçamento moderno
                  const Text(
                    "INICIALIZANDO",
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: 4.0,
                      color: Colors.black38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // BARRA DE PROGRESSO SLIM
                  SizedBox(
                    width: 180,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: LinearProgressIndicator(
                                value: _controller.value,
                                minHeight: 4, // Mais fina = mais elegante
                                color: const Color(0xFF1E9241),
                                backgroundColor: Colors.black.withOpacity(0.05),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Contador de porcentagem discreto
                            Text(
                              "${(_controller.value * 100).toInt()}%",
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}