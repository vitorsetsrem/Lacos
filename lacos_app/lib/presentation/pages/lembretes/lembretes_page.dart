import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/lembrete_model.dart';

class LembretesPage extends StatefulWidget {
  const LembretesPage({super.key});

  @override
  State<LembretesPage> createState() => _LembretesPageState();
}

class _LembretesPageState extends State<LembretesPage> {
  late final SupabaseDatasource _datasource;
  List<LembreteModel> _lembretes = [];
  bool _isLoading = true;

  static const List<Map<String, dynamic>> _tiposLembrete = [
    {'tipo': 'Anticoncepcional', 'icon': Icons.medication_rounded, 'color': 0xFFC43A4A},
    {'tipo': 'Consulta Médica', 'icon': Icons.local_hospital_rounded, 'color': 0xFFC56682},
    {'tipo': 'Exame Preventivo', 'icon': Icons.biotech_rounded, 'color': 0xFFE7A48C},
    {'tipo': 'Vacinação', 'icon': Icons.vaccines_rounded, 'color': 0xFF4CAF50},
    {'tipo': 'Ciclo Menstrual', 'icon': Icons.water_drop_rounded, 'color': 0xFFC43A4A},
  ];

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _loadLembretes();
  }

  Future<void> _loadLembretes() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await _datasource.getLembretes(user.id);
      _lembretes = data.map((json) => LembreteModel.fromJson(json)).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar lembretes: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddLembreteSheet() {
    String tipoSelecionado = 'Anticoncepcional';
    DateTime? dataSelecionada;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Novo Lembrete',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Tipo de Lembrete',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tiposLembrete.map((item) {
                    final isSelected = tipoSelecionado == item['tipo'];
                    return ChoiceChip(
                      avatar: Icon(
                        item['icon'] as IconData,
                        size: 18,
                        color: isSelected ? Colors.white : Color(item['color'] as int),
                      ),
                      label: Text(item['tipo'] as String),
                      selected: isSelected,
                      selectedColor: AppColors.primaryPink,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setSheetState(() => tipoSelecionado = item['tipo'] as String);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                Text(
                  'Data e Hora *',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setSheetState(() {
                          dataSelecionada = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightPink),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: AppColors.primaryPink, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          dataSelecionada != null
                              ? '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year} às ${dataSelecionada!.hour.toString().padLeft(2, '0')}:${dataSelecionada!.minute.toString().padLeft(2, '0')}'
                              : 'Selecione data e hora',
                          style: TextStyle(
                            color: dataSelecionada != null
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                GradientButton(
                  text: 'SALVAR LEMBRETE',
                  onPressed: () async {
                    if (dataSelecionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecione a data e hora')),
                      );
                      return;
                    }

                    final user = Supabase.instance.client.auth.currentUser;
                    if (user == null) return;

                    try {
                      await _datasource.createLembrete({
                        'usuario_id': user.id,
                        'tipo': tipoSelecionado,
                        'data': dataSelecionada!.toIso8601String(),
                        'ativo': true,
                      });
                      if (mounted) {
                        Navigator.pop(context);
                        _loadLembretes();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Meus Lembretes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.primaryPink),
            onPressed: _showAddLembreteSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink))
          : _lembretes.isEmpty
              ? _buildEmptyState()
              : _buildLembretesList(),
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
              Icons.notifications_none_rounded,
              size: 80,
              color: AppColors.salmon.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum lembrete criado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie lembretes para anticoncepcional, consultas, exames e vacinação.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'CRIAR LEMBRETE',
              onPressed: _showAddLembreteSheet,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLembretesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lembretes.length + 1,
      itemBuilder: (context, index) {
        if (index == _lembretes.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: LegalDisclaimer(),
          );
        }

        final lembrete = _lembretes[index];
        final tipoInfo = _tiposLembrete.firstWhere(
          (t) => t['tipo'] == lembrete.tipo,
          orElse: () => _tiposLembrete.first,
        );
        final color = Color(tipoInfo['color'] as int);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(tipoInfo['icon'] as IconData, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lembrete.tipo,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${lembrete.data.day.toString().padLeft(2, '0')}/${lembrete.data.month.toString().padLeft(2, '0')}/${lembrete.data.year} às ${lembrete.data.hour.toString().padLeft(2, '0')}:${lembrete.data.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: lembrete.ativo,
                activeColor: AppColors.primaryPink,
                onChanged: (value) async {
                  try {
                    await _datasource.updateLembrete(
                      lembrete.id,
                      {'ativo': value},
                    );
                    _loadLembretes();
                  } catch (e) {
                    // Handle error silently
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
