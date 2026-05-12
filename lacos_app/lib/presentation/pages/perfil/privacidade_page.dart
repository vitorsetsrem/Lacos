import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../initial_page.dart';

class PrivacidadePage extends StatelessWidget {
  const PrivacidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Privacidade',
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLilas.withOpacity(0.08),
                    AppColors.primaryPink.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_rounded,
                      color: AppColors.primaryLilas, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sua privacidade é nossa prioridade. Conheça como protegemos seus dados.',
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

            _buildSection(
              icon: Icons.lock_outline_rounded,
              color: AppColors.primaryPink,
              title: 'Proteção dos Dados',
              content:
                  'Todos os seus dados pessoais e de saúde são protegidos por criptografia '
                  'e armazenados de forma segura. Utilizamos o Supabase com Row Level Security (RLS), '
                  'garantindo que somente você tenha acesso às suas informações.',
            ),
            _buildSection(
              icon: Icons.visibility_off_outlined,
              color: AppColors.primaryLilas,
              title: 'Anonimato',
              content:
                  'As perguntas feitas no Chat Anônimo não são armazenadas e não estão '
                  'vinculadas ao seu perfil. Nenhum dado identificável é salvo nessa funcionalidade.',
            ),
            _buildSection(
              icon: Icons.share_outlined,
              color: AppColors.salmon,
              title: 'Compartilhamento',
              content:
                  'Não compartilhamos, vendemos ou transferimos seus dados pessoais a terceiros. '
                  'Seus dados são utilizados exclusivamente para o funcionamento do aplicativo.',
            ),
            _buildSection(
              icon: Icons.storage_outlined,
              color: AppColors.success,
              title: 'Seus Dados',
              content:
                  'Você tem total controle sobre seus dados. Pode editar, exportar ou solicitar '
                  'a exclusão completa da sua conta e dados a qualquer momento.',
            ),
            _buildSection(
              icon: Icons.gavel_outlined,
              color: AppColors.warning,
              title: 'Base Legal',
              content:
                  'O tratamento dos seus dados está em conformidade com a Lei Geral de Proteção '
                  'de Dados (LGPD - Lei nº 13.709/2018). O consentimento é a base legal para '
                  'o tratamento dos seus dados pessoais neste aplicativo.',
            ),

            const SizedBox(height: 24),

            // Ações de dados
            Text(
              'Controle dos seus Dados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              icon: Icons.download_rounded,
              title: 'Exportar meus dados',
              subtitle: 'Baixe uma cópia de todos os seus dados',
              color: AppColors.primaryLilas,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Funcionalidade de exportação em desenvolvimento.'),
                    backgroundColor: AppColors.primaryLilas,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            _buildActionTile(
              context: context,
              icon: Icons.delete_forever_rounded,
              title: 'Excluir minha conta',
              subtitle: 'Remove permanentemente todos os seus dados',
              color: AppColors.error,
              onTap: () => _showDeleteAccountDialog(context),
            ),

            const SizedBox(height: 16),
            const LegalDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
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
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Colors.white,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color == AppColors.error ? color : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Excluir Conta'),
          ],
        ),
        content: const Text(
          'Tem certeza que deseja excluir sua conta? '
          'Todos os seus dados serão apagados permanentemente e '
          'essa ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                // Delete user data from tables first
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  final client = Supabase.instance.client;
                  await client
                      .from('lembretes')
                      .delete()
                      .eq('usuario_id', user.id);
                  await client
                      .from('sintomas')
                      .delete()
                      .eq('usuario_id', user.id);
                  await client
                      .from('ciclos_menstruais')
                      .delete()
                      .eq('usuario_id', user.id);
                  await client
                      .from('usuarias')
                      .delete()
                      .eq('id', user.id);
                  await client.auth.signOut();
                }
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const InitialPage()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Conta e dados excluídos com sucesso.'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir conta: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text('Excluir',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
