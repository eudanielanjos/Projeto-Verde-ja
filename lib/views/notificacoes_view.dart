import 'package:flutter/material.dart';

class NotificacoesView extends StatefulWidget {
  const NotificacoesView({super.key});

  @override
  State<NotificacoesView> createState() => _NotificacoesViewState();
}

class _NotificacoesViewState extends State<NotificacoesView> {
  // Cores padronizadas do seu projeto
  final Color greenPrimary = const Color(0xFF1F5C3A);
  final Color softWhite = const Color(0xFFF8FAF9);

  // Lista mockada (em um app real, isso viria de um Provider ou Firebase)
  final List<Map<String, String>> notificacoes = [
    {
      "id": "1",
      "titulo": "Coleta Confirmada",
      "desc": "O caminhão de coleta passará na sua rua em 30 minutos.",
      "data": "Agora",
      "lida": "false",
      "tipo": "coleta"
    },
    {
      "id": "2",
      "titulo": "Nova Dica de Reciclagem",
      "desc": "Saiba como separar corretamente o vidro do plástico.",
      "data": "2h atrás",
      "lida": "false",
      "tipo": "educacao"
    },
    {
      "id": "3",
      "titulo": "Denúncia Atualizada",
      "desc": "A denúncia #1234 foi analisada pela prefeitura.",
      "data": "Ontem",
      "lida": "true",
      "tipo": "historico"
    },
  ];

  @override
  Widget build(BuildContext context) {
    int naoLidas = notificacoes.where((e) => e['lida'] == "false").length;

    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        title: const Text(
          "NOTIFICAÇÕES",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1),
        ),
        centerTitle: true,
        backgroundColor: greenPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (notificacoes.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  notificacoes.clear();
                });
              },
              child: const Text(
                "Limpar",
                style: TextStyle(color: Colors.white70
                    , fontSize: 18, fontWeight: FontWeight.w500
                  ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // --- HEADER COM TÍTULO E ÍCONE ABAIXO ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 35, top: 10),
            decoration: BoxDecoration(
              color: greenPrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Text(
                  notificacoes.isEmpty
                      ? "Nenhuma notificação por enquanto"
                      : "Você tem $naoLidas novas mensagens",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12), // Espaço entre texto e ícone
                Icon(
                  notificacoes.isEmpty
                      ? Icons.notifications_none_rounded
                      : Icons.notifications_active_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 45,
                ),
              ],
            ),
          ),

          // --- LISTA DE NOTIFICAÇÕES ---
          Expanded(
            child: notificacoes.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: notificacoes.length,
                    itemBuilder: (context, index) {
                      final item = notificacoes[index];
                      return _buildNotificationItem(item, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget para cada item (com Swipe para deletar)
  Widget _buildNotificationItem(Map<String, String> item, int index) {
    final bool isLida = item['lida'] == "true";

    return Dismissible(
      key: Key(item['id']!),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          notificacoes.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notificação removida"), duration: Duration(seconds: 1)),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isLida ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLida ? Colors.grey.shade100 : greenPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(item['tipo']!),
                  color: isLida ? Colors.grey : greenPrimary,
                  size: 24,
                ),
              ),
              if (!isLida)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            item['titulo']!,
            style: TextStyle(
              fontWeight: isLida ? FontWeight.w500 : FontWeight.bold,
              fontSize: 15,
              color: isLida ? Colors.grey.shade600 : const Color(0xFF2D312E),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item['desc']!,
                style: TextStyle(
                  fontSize: 13, 
                  color: isLida ? Colors.grey : Colors.black87
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    item['data']!, 
                    style: const TextStyle(fontSize: 11, color: Colors.grey)
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            setState(() {
              item['lida'] = "true";
            });
          },
        ),
      ),
    );
  }

  // Widget para estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Tudo limpo por aqui!",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Helper para ícones
  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'coleta':
        return Icons.local_shipping_rounded;
      case 'educacao':
        return Icons.auto_stories_rounded;
      case 'historico':
        return Icons.assignment_turned_in_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}