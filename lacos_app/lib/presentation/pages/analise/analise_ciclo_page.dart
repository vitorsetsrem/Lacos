import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/ciclo_model.dart';

class AnaliseCicloPage extends StatefulWidget {
  const AnaliseCicloPage({super.key});

  @override
  State<AnaliseCicloPage> createState() => _AnaliseCicloPageState();
}

class _AnaliseCicloPageState extends State<AnaliseCicloPage> {
  late final SupabaseDatasource _datasource;
  List<CicloModel> _ciclos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _loadData();
  }

  Future<void> _loadData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await _datasource.getCiclos(user.id);
      _ciclos = data.map((json) => CicloModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double get _mediaDuracaoCiclo {
    final ciclosComDuracao = _ciclos.where((c) => c.dataFim != null).toList();
    if (ciclosComDuracao.isEmpty) return 0;
    final total = ciclosComDuracao.fold<int>(
      0,
      (sum, c) => sum + c.dataFim!.difference(c.dataInicio).inDays,
    );
    return total / ciclosComDuracao.length;
  }

  double get _mediaIntervaloEntreCiclos {
    if (_ciclos.length < 2) return 0;
    int totalDias = 0;
    int count = 0;
    for (int i = 0; i < _ciclos.length - 1; i++) {
      final diff = _ciclos[i].dataInicio.difference(_ciclos[i + 1].dataInicio).inDays.abs();
      if (diff > 0 && diff < 60) {
        totalDias += diff;
        count++;
      }
    }
    return count > 0 ? totalDias / count : 0;
  }

  String get _regularidade {
    if (_ciclos.length < 3) return 'Dados insuficientes';
    final intervalos = <int>[];
    for (int i = 0; i < _ciclos.length - 1; i++) {
      final diff = _ciclos[i].dataInicio.difference(_ciclos[i + 1].dataInicio).inDays.abs();
      if (diff > 0 && diff < 60) intervalos.add(diff);
    }
    if (intervalos.isEmpty) return 'Dados insuficientes';
    final media = intervalos.reduce((a, b) => a + b) / intervalos.length;
    final desvio = intervalos.map((i) => (i - media).abs()).reduce((a, b) => a + b) / intervalos.length;
    if (desvio <= 3) return 'Regular';
    if (desvio <= 7) return 'Levemente irregular';
    return 'Irregular';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Análise do Ciclo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink))
          : _ciclos.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCards(),
                      const SizedBox(height: 24),
                      _buildDurationChart(),
                      const SizedBox(height: 24),
                      _buildHistorySection(),
                      const SizedBox(height: 24),
                      _buildInsightsSection(),
                      const SizedBox(height: 8),
                      const LegalDisclaimer(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_rounded,
              size: 80,
              color: AppColors.salmon.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Sem dados para análise',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Registre pelo menos 2 ciclos na aba "Meu Ciclo" para ver análises e estatísticas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo do Ciclo',
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
              child: _buildStatCard(
                icon: Icons.water_drop_rounded,
                label: 'Duração Média',
                value: _mediaDuracaoCiclo > 0
                    ? '${_mediaDuracaoCiclo.toStringAsFixed(0)} dias'
                    : '--',
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.loop_rounded,
                label: 'Intervalo Médio',
                value: _mediaIntervaloEntreCiclos > 0
                    ? '${_mediaIntervaloEntreCiclos.toStringAsFixed(0)} dias'
                    : '--',
                color: AppColors.primaryLilas,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.timeline_rounded,
                label: 'Regularidade',
                value: _regularidade,
                color: AppColors.salmon,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.format_list_numbered_rounded,
                label: 'Ciclos Registrados',
                value: '${_ciclos.length}',
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChart() {
    final ciclosComDuracao = _ciclos.where((c) => c.dataFim != null).take(8).toList().reversed.toList();
    if (ciclosComDuracao.isEmpty) return const SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duração dos Últimos Ciclos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: ciclosComDuracao
                        .map((c) => c.dataFim!.difference(c.dataInicio).inDays.toDouble())
                        .reduce((a, b) => a > b ? a : b) +
                    3,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < ciclosComDuracao.length) {
                          final ciclo = ciclosComDuracao[index];
                          return Text(
                            '${ciclo.dataInicio.month}/${ciclo.dataInicio.year.toString().substring(2)}',
                            style: TextStyle(fontSize: 10, color: AppColors.textLight),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}d',
                        style: TextStyle(fontSize: 10, color: AppColors.textLight),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.textLight.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: ciclosComDuracao.asMap().entries.map((entry) {
                  final duracao = entry.value.dataFim!.difference(entry.value.dataInicio).inDays.toDouble();
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: duracao,
                        gradient: AppColors.primaryGradient,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico Recente',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...(_ciclos.take(5).map((ciclo) {
          final duracao = ciclo.dataFim != null
              ? ciclo.dataFim!.difference(ciclo.dataInicio).inDays
              : null;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${ciclo.dataInicio.day.toString().padLeft(2, '0')}/${ciclo.dataInicio.month.toString().padLeft(2, '0')}/${ciclo.dataInicio.year}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (duracao != null)
                  Text(
                    '$duracao dias',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (ciclo.intensidade != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.salmon.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ciclo.intensidade!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.salmon,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        })),
      ],
    );
  }

  Widget _buildInsightsSection() {
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
                'Insights Educativos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _getInsight(),
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

  String _getInsight() {
    if (_ciclos.length < 3) {
      return 'Continue registrando seus ciclos! Com pelo menos 3 registros, '
          'poderemos oferecer insights mais precisos sobre seu padrão menstrual.';
    }
    final reg = _regularidade;
    if (reg == 'Regular') {
      return 'Seu ciclo está regular! Isso é um bom indicador de saúde hormonal. '
          'Continue monitorando e mantendo hábitos saudáveis.';
    }
    if (reg == 'Levemente irregular') {
      return 'Seu ciclo apresenta leve irregularidade, o que pode ser normal. '
          'Fatores como estresse, alimentação e exercícios influenciam. '
          'Se persistir por mais de 3 meses, converse com um profissional.';
    }
    return 'Seu ciclo está com irregularidade significativa. '
        'Isso pode ter diversas causas. Recomendamos procurar uma UBS '
        'para avaliação com profissional de saúde.';
  }
}
