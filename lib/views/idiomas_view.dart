import 'package:flutter/material.dart';

class IdiomasView extends StatefulWidget {
  const IdiomasView({super.key});

  @override
  State<IdiomasView> createState() => _IdiomasViewState();
}

class _IdiomasViewState extends State<IdiomasView> {

  String idiomaSelecionado = "Português";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Idiomas e Traduções"),
        backgroundColor: const Color(0xFF1F5C3A),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(120, 159, 130, 1),
              Colors.white,
            ],
            stops: [0.0, 0.2],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 20),

              _buildIdioma("Português", "🇧🇷"),
              _buildIdioma("English", "🇺🇸"),
              _buildIdioma("Español", "🇪🇸"),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdioma(String idioma, String bandeira) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: InkWell(
        onTap: () {
          setState(() {
            idiomaSelecionado = idioma;
          });
        },

        borderRadius: BorderRadius.circular(15),

        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),

          decoration: BoxDecoration(
            color: const Color(0xFF5E7F6B),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Row(
            children: [

              Text(
                bandeira,
                style: const TextStyle(fontSize: 24),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Text(
                  idioma,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (idiomaSelecionado == idioma)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )

            ],
          ),
        ),
      ),
    );
  }
}