import 'package:flutter/material.dart';

class HistoricoDenunciasView extends StatefulWidget {
  const HistoricoDenunciasView({super.key});

  @override
  State<HistoricoDenunciasView> createState() => _HistoricoDenunciasViewState();
}

class _HistoricoDenunciasViewState extends State<HistoricoDenunciasView> {

  final List<Map<String, String>> denuncias = [
    {
      "titulo": "Lixo em área verde",
      "data": "08/03/2026",
      "status": "Em análise"
    },
    {
      "titulo": "Queimada ilegal",
      "data": "05/03/2026",
      "status": "Resolvido"
    },
    {
      "titulo": "Poluição no rio",
      "data": "01/03/2026",
      "status": "Em análise"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Histórico de denúncias",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F5C3A),
        iconTheme: const IconThemeData(
          color: Colors.white, // deixa o botão de voltar branco
        ),
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

        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: denuncias.length,
          itemBuilder: (context, index) {

            final denuncia = denuncias[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: ListTile(

                leading: const Icon(
                  Icons.report_problem,
                  color: Color(0xFF1F5C3A),
                ),

                title: Text(
                  denuncia["titulo"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  "Data: ${denuncia["data"]}",
                ),

                trailing: Text(
                  denuncia["status"]!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            );
          },
        ),
      ),
    );
  }
}