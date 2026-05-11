import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/legal_disclaimer.dart';

class RedeApoioPage extends StatelessWidget {
  const RedeApoioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Rede de Apoio',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPink.withOpacity(0.08),
                    AppColors.salmon.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppColors.primaryPink,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Você não está sozinha. Conheça os serviços de apoio disponíveis para você.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Serviços de Emergência',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              context: context,
              icon: Icons.phone_in_talk_rounded,
              title: 'Disque 180',
              subtitle: 'Central de Atendimento à Mulher',
              description: 'Denúncias de violência, orientação e encaminhamento. Funciona 24h, gratuito e sigiloso.',
              phone: '180',
              color: AppColors.primaryPink,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.local_police_rounded,
              title: 'Delegacia da Mulher',
              subtitle: 'Delegacia Especializada',
              description: 'Atendimento especializado para mulheres vítimas de violência doméstica e sexual.',
              phone: '190',
              color: AppColors.primaryLilas,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.favorite_rounded,
              title: 'CVV - Centro de Valorização da Vida',
              subtitle: 'Apoio emocional e prevenção do suicídio',
              description: 'Ligação gratuita, 24 horas, sigilo absoluto. Também disponível por chat.',
              phone: '188',
              color: AppColors.salmon,
            ),

            const SizedBox(height: 24),
            Text(
              'Serviços de Saúde e Assistência',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              context: context,
              icon: Icons.local_hospital_rounded,
              title: 'UBS - Unidade Básica de Saúde',
              subtitle: 'Atenção primária à saúde',
              description: 'Consultas, exames preventivos (Papanicolau, mamografia), pré-natal, vacinação e acompanhamento de saúde da mulher.',
              phone: '136',
              color: AppColors.success,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.people_rounded,
              title: 'CRAS',
              subtitle: 'Centro de Referência de Assistência Social',
              description: 'Atendimento a famílias em situação de vulnerabilidade. Oferece programas sociais e orientação.',
              phone: null,
              color: AppColors.warning,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.shield_rounded,
              title: 'CREAS',
              subtitle: 'Centro de Referência Especializado',
              description: 'Atendimento especializado a pessoas em situação de ameaça ou violação de direitos.',
              phone: null,
              color: AppColors.primaryLilas,
            ),

            const SizedBox(height: 24),
            Text(
              'Outros Contatos Úteis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              context: context,
              icon: Icons.emergency_rounded,
              title: 'SAMU',
              subtitle: 'Serviço de Atendimento Móvel de Urgência',
              description: 'Emergências médicas 24 horas.',
              phone: '192',
              color: AppColors.error,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.health_and_safety_rounded,
              title: 'Disque Saúde',
              subtitle: 'Informações sobre serviços do SUS',
              description: 'Informações sobre campanhas, doenças e unidades de saúde.',
              phone: '136',
              color: AppColors.success,
            ),

            const SizedBox(height: 8),
            const LegalDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required String? phone,
    required Color color,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (phone != null)
                GestureDetector(
                  onTap: () async {
                    final uri = Uri(scheme: 'tel', path: phone);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      Clipboard.setData(ClipboardData(text: phone));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Número $phone copiado!'),
                            backgroundColor: color,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
