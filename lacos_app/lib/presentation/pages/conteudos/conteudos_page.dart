import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/conteudo_model.dart';
import '../../../data/repositories/conteudo_repository.dart';
import 'conteudo_detail_page.dart';

class ConteudosPage extends StatefulWidget {
  const ConteudosPage({super.key});

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  late final ConteudoRepository _repository;
  List<ConteudoModel> _conteudos = [];
  bool _isLoading = true;
  String? _selectedCategoria;

  final Map<String, IconData> _categoryIcons = {
    'Saúde Ginecológica': Icons.favorite_rounded,
    'Ciclo Menstrual': Icons.water_drop_rounded,
    'Saúde Preventiva': Icons.shield_rounded,
    'Saúde Emocional/Hormonal': Icons.psychology_rounded,
    'Fases da Vida': Icons.auto_awesome_rounded,
    'Violência Contra a Mulher': Icons.security_rounded,
    'Autocuidado': Icons.spa_rounded,
  };

  @override
  void initState() {
    super.initState();
    final datasource = SupabaseDatasource(Supabase.instance.client);
    _repository = ConteudoRepository(datasource);
    _loadConteudos();
  }

  Future<void> _loadConteudos() async {
    setState(() => _isLoading = true);
    try {
      if (_selectedCategoria != null) {
        _conteudos =
            await _repository.getConteudosByCategoria(_selectedCategoria!);
      } else {
        _conteudos = await _repository.getConteudos();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar conteúdos: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Conteúdos',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filtro por categoria
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppStrings.categorias.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = _selectedCategoria == null;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('Todos'),
                      selected: isSelected,
                      selectedColor: AppColors.primaryPink.withOpacity(0.2),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primaryPink
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (_) {
                        setState(() => _selectedCategoria = null);
                        _loadConteudos();
                      },
                    ),
                  );
                }

                final categoria = AppStrings.categorias[index - 1];
                final isSelected = _selectedCategoria == categoria;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(categoria),
                    selected: isSelected,
                    selectedColor: AppColors.primaryPink.withOpacity(0.2),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? AppColors.primaryPink
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (_) {
                      setState(() => _selectedCategoria = categoria);
                      _loadConteudos();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryPink))
                : _conteudos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book_rounded,
                                size: 64,
                                color:
                                    AppColors.primaryLilas.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            Text('Nenhum conteúdo encontrado',
                                style: TextStyle(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _conteudos.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _conteudos.length) {
                            return const LegalDisclaimer();
                          }

                          final conteudo = _conteudos[index];
                          return _buildConteudoCard(conteudo);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildConteudoCard(ConteudoModel conteudo) {
    final icon =
        _categoryIcons[conteudo.categoria] ?? Icons.article_rounded;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ConteudoDetailPage(conteudo: conteudo),
          ),
        );
      },
      child: Container(
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
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conteudo.titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conteudo.categoria,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryLilas,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (conteudo.descricao != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      conteudo.descricao!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
