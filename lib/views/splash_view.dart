import 'dart:async';
import 'package:flutter/material.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
@override
  State<SplashView> createState() => _SplashView();
}

class _SplashView extends State<SplashView>
  with SingleTickerProviderStateMixin{
    late AnimationController _controller;

    @override
    void initState(){
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        );
      _controller.forward();
      Future.delayed(const Duration(seconds: 3), () {
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
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: [
                Color.fromARGB(255, 30, 146, 65),
                Color.fromARGB(255, 247, 247, 247),
              ]
              ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo3.png',
                  width: 250,
              ),
              SizedBox (height: 40),
              SizedBox(
                width: 220,
                child: AnimatedBuilder(
                animation: _controller, 
                builder: (context, child){
                  return LinearProgressIndicator(
                    value: _controller.value,
                    color: Color.fromARGB(255, 46, 148, 104),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  );
                }
                ),
              )
            ],
          ),
        )
      );
    }
  }
  

/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

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
            colors: [
              Color.fromARGB(255, 63, 129, 37),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 220,
              height: 25,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  int percentage = (_controller.value * 100).toInt();

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 8,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
    );
  }
}
*/ 