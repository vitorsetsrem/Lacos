import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final SupabaseDatasource _datasource;
  int _totalCiclos = 0;
  int _totalSintomas = 0;
  int _totalLembretes = 0;
  bool _isLoading = true;

  final List<String> _dicas = [
    'Beba pelo menos 2 litros de água por dia para manter seu corpo hidratado.',
    'Pratique atividade física regularmente — caminhadas de 30 min já fazem diferença!',
    'Durma pelo menos 7 horas por noite para manter a saúde hormonal.',
    'Reserve um tempo para você todos os dias, mesmo que sejam 10 minutos.',
    'Anote seus sintomas — isso ajuda a conhecer melhor seu corpo.',
    'Mantenha seus exames preventivos em dia. O Papanicolau salva vidas!',
    'Respire fundo e solte devagar. Pequenas pausas aliviam o estresse.',
  ];

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final ciclos = await _datasource.getCiclos(user.id);
      final sintomas = await _datasource.getSintomas(user.id);
      final lembretes = await _datasource.getLembretes(user.id);
      _totalCiclos = ciclos.length;
      _totalSintomas = sintomas.length;
      _totalLembretes = lembretes.length;
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  String get _dicaDoDia {
    final index = DateTime.now().day % _dicas.length;
    return _dicas[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.dashboardTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink))
          : RefreshIndicator(
              onRefresh: _loadStats,
              color: AppColors.primaryPink,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saudação
                    Text(
                      'Olá! ${_getGreeting()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gráfico de Pizza
                    _buildPieChart(),
                    const SizedBox(height: 24),

                    // Cards de progresso
                    Text(
                      'Seu Resumo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProgressCard(
                            title: AppStrings.preventiva,
                            value: '$_totalCiclos',
                            subtitle: 'Ciclos registrados',
                            icon: Icons.water_drop_rounded,
                            color: AppColors.primaryPink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProgressCard(
                            title: AppStrings.cuidadoComigo,
                            value: '$_totalSintomas',
                            subtitle: 'Sintomas anotados',
                            icon: Icons.favorite_rounded,
                            color: AppColors.primaryLilas,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildProgressCard(
                      title: AppStrings.controleRemedios,
                      value: '$_totalLembretes',
                      subtitle: 'Lembretes ativos',
                      icon: Icons.alarm_rounded,
                      color: AppColors.salmon,
                    ),
                    const SizedBox(height: 24),

                    // Dica do dia
                    _buildDicaDoDia(),
                    const SizedBox(height: 8),
                    const LegalDisclaimer(),
                  ],
                ),
              ),
            ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia!';
    if (hour < 18) return 'Boa tarde!';
    return 'Boa noite!';
  }

  Widget _buildPieChart() {
    final total = _totalCiclos + _totalSintomas + _totalLembretes;
    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.pie_chart_outline_rounded,
                  size: 48, color: AppColors.textLight),
              const SizedBox(height: 12),
              Text(
                'Comece registrando seus ciclos e sintomas para ver seu progresso aqui!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Seus Registros',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: _totalCiclos.toDouble(),
                    color: AppColors.primaryPink,
                    title: '$_totalCiclos',
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: _totalSintomas.toDouble(),
                    color: AppColors.primaryLilas,
                    title: '$_totalSintomas',
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: _totalLembretes.toDouble(),
                    color: AppColors.salmon,
                    title: '$_totalLembretes',
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    radius: 50,
                  ),
                ],
                sectionsSpace: 3,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegend('Ciclos', AppColors.primaryPink),
              _buildLegend('Sintomas', AppColors.primaryLilas),
              _buildLegend('Lembretes', AppColors.salmon),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDicaDoDia() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cream,
            AppColors.softPink.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightPink.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppColors.salmon, size: 20),
              const SizedBox(width: 8),
              Text(
                'Dica do Dia',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _dicaDoDia,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
