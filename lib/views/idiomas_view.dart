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
      title: const Text(
        "Idiomas e Traduções",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
  backgroundColor: const Color(0xFF1F5C3A),
  foregroundColor: Colors.white,

  
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

              const SizedBox(height: 10),

              const Icon(
                Icons.language,
                size: 40,
                color: Color(0xFF1F5C3A),
              ),

              const SizedBox(height: 10),

              const Text(
                "Escolha o idioma do aplicativo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5C3A),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "O idioma selecionado será usado em todo o aplicativo.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

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
    bool selecionado = idiomaSelecionado == idioma;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: InkWell(
        onTap: () {
          setState(() {
            idiomaSelecionado = idioma;
          });
        },

        borderRadius: BorderRadius.circular(15),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),

          decoration: BoxDecoration(
            color: const Color(0xFF5E7F6B),

            borderRadius: BorderRadius.circular(15),

            border: selecionado
                ? Border.all(color: const Color(0xFF1F5C3A), width: 3)
                : null,
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

              if (selecionado)
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