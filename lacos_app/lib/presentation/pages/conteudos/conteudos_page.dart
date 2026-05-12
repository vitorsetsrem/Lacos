import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/conteudo_model.dart';
import 'conteudo_detail_page.dart';

class ConteudosPage extends StatefulWidget {
  const ConteudosPage({super.key});

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  late final SupabaseDatasource _datasource;
  List<ConteudoModel> _conteudos = [];
  String? _categoriaSelecionada;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _loadConteudos();
  }

  Future<void> _loadConteudos() async {
    setState(() => _isLoading = true);
    try {
      final data = _categoriaSelecionada != null
          ? await _datasource.getConteudosByCategoria(_categoriaSelecionada!)
          : await _datasource.getConteudos();
      _conteudos = data.map((json) => ConteudoModel.fromJson(json)).toList();
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
          // Filtro de categorias
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('Todos', null),
                ...AppStrings.categorias
                    .map((cat) => _buildFilterChip(cat, cat)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lista de conteúdos
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryPink))
                : _conteudos.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum conteúdo encontrado.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _conteudos.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _conteudos.length) {
                            return const LegalDisclaimer();
                          }
                          return _buildConteudoCard(_conteudos[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? categoria) {
    final isSelected = _categoriaSelecionada == categoria;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primaryPink,
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
        onSelected: (_) {
          setState(() => _categoriaSelecionada = categoria);
          _loadConteudos();
        },
      ),
    );
  }

  Widget _buildConteudoCard(ConteudoModel conteudo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
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
                color: AppColors.primaryLilas.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.primaryLilas,
              ),
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
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
