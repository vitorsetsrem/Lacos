import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/models/conteudo_model.dart';

class ConteudoDetailPage extends StatelessWidget {
  final ConteudoModel conteudo;

  const ConteudoDetailPage({super.key, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primaryPink,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                conteudo.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 48,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoria badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLilas.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      conteudo.categoria,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLilas,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição
                  if (conteudo.descricao != null) ...[
                    Text(
                      conteudo.descricao!,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Seções obrigatórias
                  if (conteudo.oQueENormal != null)
                    _buildSection(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'O que é normal',
                      content: conteudo.oQueENormal!,
                      color: AppColors.success,
                    ),

                  if (conteudo.sinaisAlerta != null)
                    _buildSection(
                      icon: Icons.warning_amber_rounded,
                      title: 'Sinais de alerta',
                      content: conteudo.sinaisAlerta!,
                      color: AppColors.warning,
                    ),

                  if (conteudo.quandoProcurarUbs != null)
                    _buildSection(
                      icon: Icons.local_hospital_rounded,
                      title: 'Quando procurar a UBS',
                      content: conteudo.quandoProcurarUbs!,
                      color: AppColors.error,
                    ),

                  if (conteudo.oQueFazerEmCasa != null)
                    _buildSection(
                      icon: Icons.home_rounded,
                      title: 'O que fazer em casa',
                      content: conteudo.oQueFazerEmCasa!,
                      color: AppColors.primaryLilas,
                    ),

                  const LegalDisclaimer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
