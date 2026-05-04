import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/ciclo_model.dart';
import '../../../data/repositories/ciclo_repository.dart';

class CicloPage extends StatefulWidget {
  const CicloPage({super.key});

  @override
  State<CicloPage> createState() => _CicloPageState();
}

class _CicloPageState extends State<CicloPage> {
  late final CicloRepository _cicloRepository;
  List<CicloModel> _ciclos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final datasource = SupabaseDatasource(Supabase.instance.client);
    _cicloRepository = CicloRepository(datasource);
    _loadCiclos();
  }

  Future<void> _loadCiclos() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      _ciclos = await _cicloRepository.getCiclos(user.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar ciclos: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddCicloSheet() {
    DateTime? dataInicio;
    DateTime? dataFim;
    String intensidade = 'Moderado';
    final observacoesController = TextEditingController();

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
                  'Registrar Ciclo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Data início
                Text('Data de Início *',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setSheetState(() => dataInicio = picked);
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
                        Icon(Icons.calendar_today,
                            color: AppColors.primaryPink, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          dataInicio != null
                              ? '${dataInicio!.day.toString().padLeft(2, '0')}/${dataInicio!.month.toString().padLeft(2, '0')}/${dataInicio!.year}'
                              : 'Selecione a data',
                          style: TextStyle(
                            color: dataInicio != null
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Data fim
                Text('Data de Fim',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dataInicio ?? DateTime.now(),
                      firstDate: dataInicio ?? DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 15)),
                    );
                    if (picked != null) {
                      setSheetState(() => dataFim = picked);
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
                        Icon(Icons.calendar_today,
                            color: AppColors.primaryLilas, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          dataFim != null
                              ? '${dataFim!.day.toString().padLeft(2, '0')}/${dataFim!.month.toString().padLeft(2, '0')}/${dataFim!.year}'
                              : 'Selecione a data (opcional)',
                          style: TextStyle(
                            color: dataFim != null
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Intensidade
                Text('Intensidade',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Leve', 'Moderado', 'Intenso'].map((option) {
                    final isSelected = intensidade == option;
                    return ChoiceChip(
                      label: Text(option),
                      selected: isSelected,
                      selectedColor: AppColors.primaryPink.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primaryPink
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setSheetState(() => intensidade = option);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Observações
                Text('Observações',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: observacoesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Anotações sobre este ciclo...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão salvar
                GradientButton(
                  text: 'SALVAR',
                  onPressed: () async {
                    if (dataInicio == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Selecione a data de início')),
                      );
                      return;
                    }

                    final user = Supabase.instance.client.auth.currentUser;
                    if (user == null) return;

                    try {
                      final ciclo = CicloModel(
                        id: '',
                        usuarioId: user.id,
                        dataInicio: dataInicio!,
                        dataFim: dataFim,
                        intensidade: intensidade,
                        observacoes: observacoesController.text.isNotEmpty
                            ? observacoesController.text
                            : null,
                      );
                      await _cicloRepository.createCiclo(ciclo);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadCiclos();
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
          'Meu Ciclo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.primaryPink),
            onPressed: _showAddCicloSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink))
          : _ciclos.isEmpty
              ? _buildEmptyState()
              : _buildCiclosList(),
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
              Icons.calendar_month_rounded,
              size: 80,
              color: AppColors.primaryPink.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum ciclo registrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque no + para registrar seu primeiro ciclo menstrual',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'REGISTRAR CICLO',
              onPressed: _showAddCicloSheet,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCiclosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ciclos.length + 1,
      itemBuilder: (context, index) {
        if (index == _ciclos.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: LegalDisclaimer(),
          );
        }

        final ciclo = _ciclos[index];
        final duracao = ciclo.dataFim != null
            ? ciclo.dataFim!.difference(ciclo.dataInicio).inDays
            : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.06),
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
                  color: AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.primaryPink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${ciclo.dataInicio.day.toString().padLeft(2, '0')}/${ciclo.dataInicio.month.toString().padLeft(2, '0')}/${ciclo.dataInicio.year}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (duracao != null)
                      Text(
                        '$duracao dias • ${ciclo.intensidade ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (ciclo.observacoes != null &&
                        ciclo.observacoes!.isNotEmpty)
                      Text(
                        ciclo.observacoes!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              _buildIntensidadeIndicator(ciclo.intensidade),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntensidadeIndicator(String? intensidade) {
    Color color;
    switch (intensidade?.toLowerCase()) {
      case 'leve':
        color = AppColors.success;
        break;
      case 'intenso':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        intensidade ?? 'Moderado',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
