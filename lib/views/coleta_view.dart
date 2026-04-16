import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Importações para o menu
import 'perfil_view.dart';
import 'educacao_view.dart';
import 'config_view.dart';
import 'historico_denuncias_view.dart';
import 'home_view.dart';
import 'tela_inicial_view.dart';

class ColetaView extends StatefulWidget {
  const ColetaView({super.key});

  @override
  State<ColetaView> createState() => _ColetaViewState();
}

class _ColetaViewState extends State<ColetaView> {
  DateTime? dataInicial;
  DateTime? dataFinal;
  DateTime focusedDay = DateTime.now();

  final List<String> caminhosImagens = [
    'assets/images/vidro.png',
    'assets/images/plastico.png',
    'assets/images/papel.png',
    'assets/images/metal.png',
    'assets/images/entulho.png',
  ];

  final List<String> nomesMateriais = [
    'Vidro',
    'Plástico',
    'Papel',
    'Metal',
    'Entulho',
  ];

  final Map<int, Color> coresMateriais = {
    0: const Color(0xFF00C853), // Vidro
    1: const Color(0xFFF44336), // Plástico
    2: const Color(0xFF2196F3), // Papel
    3: const Color(0xFFFFD600), // Metal
    4: const Color(0xFF1B5E20), // Entulho
  };

  List<bool> selecionados = [false, false, false, false, false];

  // --- LÓGICA DO CALENDÁRIO ---
  bool _deveMostrarEvento(DateTime day, int index) {
    if (!selecionados[index]) return false;
    int semanaDoMes = ((day.day - 1) / 7).floor() + 1;
    bool isUltimaSemana = day.day > (DateUtils.getDaysInMonth(day.year, day.month) - 7);

    switch (index) {
      case 0: return day.weekday == DateTime.wednesday && semanaDoMes == 2;
      case 1: return day.weekday == DateTime.monday && semanaDoMes == 1;
      case 2: return day.weekday == DateTime.monday && semanaDoMes == 4;
      case 3: return day.weekday == DateTime.friday && semanaDoMes == 3;
      case 4: return day.weekday == DateTime.friday && isUltimaSemana;
      default: return false;
    }
  }

  Color _getCorParaDia(DateTime day) {
    for (int i = 0; i < selecionados.length; i++) {
      if (selecionados[i] && _deveMostrarEvento(day, i)) {
        return coresMateriais[i]!;
      }
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 25),
              decoration: const BoxDecoration(color: Color(0xFF1F5C3A)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Olá, Usuario",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildMenuCard(
                    icon: Icons.home,
                    title: "Início",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaInicialView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.calendar_month,
                    title: "Coleta Regular",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuCard(
                    icon: Icons.school,
                    title: "Educação",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EducacaoView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.history_edu,
                    title: "Histórico de Denúncias",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoDenunciasView()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.settings,
                    title: "Configurações",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracaoPage()));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Sair da conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              Builder(
                builder: (context) => Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),

              const Text(
                'Cronograma de coleta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1F5C3A), letterSpacing: -0.5),
              ),
              
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(child: _buildDataButton(context, true)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildDataButton(context, false)),
                ],
              ),
              
              _buildFiltroLimparButtons(),
              
              _buildCalendar(),
              
              const SizedBox(height: 25),
              
              const Text('Filtrar por tipo:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              
              const SizedBox(height: 15),
              
              _buildImageFilters(),
              
              const SizedBox(height: 30),
              
              _buildBottomButton('Pontos de coleta', 'assets/images/icon_reciclagem.png', true),
              const SizedBox(height: 15),
              _buildBottomButton('Caminhões próximos', null, false),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1F5C3A)),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFF1F5C3A), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 40,
            color: const Color(0xFF1F5C3A),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeekLabel('D'), _WeekLabel('S'), _WeekLabel('T'),
                _WeekLabel('Q'), _WeekLabel('Q'), _WeekLabel('S'), _WeekLabel('S'),
              ],
            ),
          ),
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            headerVisible: false,
            daysOfWeekVisible: false,
            rowHeight: 52,
            sixWeekMonthsEnforced: true,
            calendarStyle: const CalendarStyle(cellMargin: EdgeInsets.zero, outsideDaysVisible: false),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, fDay) => _buildCustomCell(day, const Color(0xFF9FB1A3)),
              todayBuilder: (context, day, fDay) => _buildCustomCell(day, const Color(0xFF9FB1A3), isToday: true),
            ),
            onDaySelected: (selectedDay, focusedDayNew) {
              setState(() {
                focusedDay = focusedDayNew;
                if (dataInicial == null) {
                  dataInicial = selectedDay;
                } else if (dataFinal == null) dataFinal = selectedDay;
                else { dataInicial = selectedDay; dataFinal = null; }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCell(DateTime day, Color defaultBgColor, {bool isToday = false}) {
    final Color corEvento = _getCorParaDia(day);
    final bool temEvento = corEvento != Colors.transparent;

    return Container(
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: temEvento ? corEvento : defaultBgColor,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4, top: 2,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 12,
                color: temEvento ? Colors.white.withOpacity(0.8) : Colors.black45,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (temEvento)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_filled, color: Colors.white, size: 14),
                  Text('17H', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(caminhosImagens.length, (index) {
          return GestureDetector(
            onTap: () => setState(() => selecionados[index] = !selecionados[index]),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: selecionados[index] ? Colors.green.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    border: selecionados[index] ? Border.all(color: Colors.green, width: 2) : null,
                  ),
                  child: Image.asset(caminhosImagens[index], width: 60, height: 60, fit: BoxFit.contain),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    nomesMateriais[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selecionados[index] ? FontWeight.bold : FontWeight.w500,
                      color: selecionados[index] ? Colors.green[800] : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDataButton(BuildContext context, bool isInicial) {
    DateTime? data = isInicial ? dataInicial : dataFinal;
    return ElevatedButton(
      onPressed: () => isInicial ? _selecionarDataInicial(context) : _selecionarDataFinal(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined, size: 18, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(data == null ? (isInicial ? 'Data Inicial' : 'Data Final') : '${data.day}/${data.month}/${data.year % 100}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBottomButton(String label, String? asset, bool isReciclagem) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: const Color.fromRGBO(137, 186, 21, 0.3), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(137, 186, 21, 1),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        icon: asset != null ? Image.asset(asset, width: 22, height: 22) : const Icon(Icons.location_on_rounded, size: 22),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFiltroLimparButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => setState(() {
          dataInicial = null;
          dataFinal = null;
          selecionados = List.filled(caminhosImagens.length, false);
        }),
        icon: const Icon(Icons.refresh, size: 16, color: Colors.grey),
        label: const Text('Limpar filtros', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }

  Future<void> _selecionarDataInicial(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: dataInicial ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) setState(() => dataInicial = picked);
  }

  Future<void> _selecionarDataFinal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: dataFinal ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) setState(() => dataFinal = picked);
  }
}

class _WeekLabel extends StatelessWidget {
  final String label;
  const _WeekLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12));
}