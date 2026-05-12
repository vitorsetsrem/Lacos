import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool _cicloAtivo = true;
  bool _lembreteAtivo = true;
  bool _conteudoAtivo = false;
  bool _dicaDoDiaAtivo = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cicloAtivo = prefs.getBool('notif_ciclo') ?? true;
      _lembreteAtivo = prefs.getBool('notif_lembrete') ?? true;
      _conteudoAtivo = prefs.getBool('notif_conteudo') ?? false;
      _dicaDoDiaAtivo = prefs.getBool('notif_dica') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notificações',
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
          : SingleChildScrollView(
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
                          AppColors.primaryPink.withOpacity(0.08),
                          AppColors.salmon.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_active_rounded,
                            color: AppColors.primaryPink, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Configure quais notificações deseja receber para cuidar melhor da sua saúde.',
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

                  // Saúde e Ciclo
                  _buildSectionTitle('Saúde e Ciclo'),
                  const SizedBox(height: 12),
                  _buildNotificationTile(
                    icon: Icons.water_drop_rounded,
                    color: AppColors.primaryPink,
                    title: 'Lembrete do Ciclo',
                    subtitle:
                        'Aviso quando a menstruação estiver próxima com base no seu histórico.',
                    value: _cicloAtivo,
                    onChanged: (v) {
                      setState(() => _cicloAtivo = v);
                      _savePreference('notif_ciclo', v);
                    },
                  ),
                  _buildNotificationTile(
                    icon: Icons.alarm_rounded,
                    color: AppColors.salmon,
                    title: 'Lembretes Agendados',
                    subtitle:
                        'Anticoncepcional, consultas, exames e vacinação.',
                    value: _lembreteAtivo,
                    onChanged: (v) {
                      setState(() => _lembreteAtivo = v);
                      _savePreference('notif_lembrete', v);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Conteúdo
                  _buildSectionTitle('Conteúdo Educativo'),
                  const SizedBox(height: 12),
                  _buildNotificationTile(
                    icon: Icons.auto_stories_rounded,
                    color: AppColors.primaryLilas,
                    title: 'Novos Conteúdos',
                    subtitle:
                        'Receba avisos quando novos artigos educativos forem publicados.',
                    value: _conteudoAtivo,
                    onChanged: (v) {
                      setState(() => _conteudoAtivo = v);
                      _savePreference('notif_conteudo', v);
                    },
                  ),
                  _buildNotificationTile(
                    icon: Icons.lightbulb_outline_rounded,
                    color: AppColors.warning,
                    title: 'Dica do Dia',
                    subtitle:
                        'Uma dica diária sobre saúde feminina e autocuidado.',
                    value: _dicaDoDiaAtivo,
                    onChanged: (v) {
                      setState(() => _dicaDoDiaAtivo = v);
                      _savePreference('notif_dica', v);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.lightPink.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: AppColors.textLight, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'As notificações são armazenadas localmente no seu dispositivo. '
                            'Você pode alterar essas configurações a qualquer momento.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primaryPink,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
