import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/legal_disclaimer.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/usuaria_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../initial_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late final AuthRepository _authRepository;
  late final SupabaseDatasource _datasource;
  UsuariaModel? _usuaria;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _authRepository = AuthRepository(_datasource);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await _datasource.getUsuaria(user.id);
      if (data != null) {
        _usuaria = UsuariaModel.fromJson(data);
      }
    } catch (e) {
      // Profile may not exist yet
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                Text('Sair', style: TextStyle(color: AppColors.primaryPink)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authRepository.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const InitialPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Meu Perfil',
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
                children: [
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPink.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _usuaria?.nome.isNotEmpty == true
                            ? _usuaria!.nome[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _usuaria?.nome ?? 'Usuária',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Opções
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Editar Perfil',
                    onTap: () {
                      // TODO: editar perfil
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    onTap: () {
                      // TODO: configurações de notificação
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacidade',
                    onTap: () {
                      // TODO: política de privacidade
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Ajuda',
                    onTap: () {
                      // TODO: página de ajuda
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Sobre o App',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppStrings.appFullName,
                        applicationVersion: '1.0.0',
                        children: [
                          const SizedBox(height: 12),
                          Text(AppStrings.avisoLegal,
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Botão sair
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: Icon(Icons.logout_rounded,
                          color: AppColors.primaryPink),
                      label: Text(
                        'Sair da Conta',
                        style: TextStyle(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(color: AppColors.primaryPink),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const LegalDisclaimer(),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        tileColor: Colors.white,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.pastelPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryPink, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
