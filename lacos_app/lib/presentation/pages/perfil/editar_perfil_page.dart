import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/datasources/supabase_datasource.dart';
import '../../../data/models/usuaria_model.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  late final SupabaseDatasource _datasource;
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  String? _faseSelecionada;
  bool _isLoading = true;
  bool _isSaving = false;
  UsuariaModel? _usuaria;

  static const List<String> _fases = [
    'Adolescente',
    'Adulta',
    'Gestante',
    'Pós-parto',
    'Menopausa',
  ];

  @override
  void initState() {
    super.initState();
    _datasource = SupabaseDatasource(Supabase.instance.client);
    _loadProfile();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await _datasource.getUsuaria(user.id);
      if (data != null) {
        _usuaria = UsuariaModel.fromJson(data);
        _nomeController.text = _usuaria!.nome;
        _idadeController.text =
            _usuaria!.idade != null ? _usuaria!.idade.toString() : '';
        _faseSelecionada = _usuaria!.faseDaVida;
      }
    } catch (e) {
      // Profile may not exist yet
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      final updateData = <String, dynamic>{
        'nome': _nomeController.text.trim(),
        'fase_da_vida': _faseSelecionada,
      };

      final idadeText = _idadeController.text.trim();
      if (idadeText.isNotEmpty) {
        updateData['idade'] = int.tryParse(idadeText);
      }

      await _datasource.updateUsuaria(user.id, updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil atualizado com sucesso!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          'Editar Perfil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryPink.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _nomeController.text.isNotEmpty
                                    ? _nomeController.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  size: 16, color: AppColors.primaryPink),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Nome
                    _buildLabel('Nome Completo'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nomeController,
                      decoration: _inputDecoration(
                        hint: 'Seu nome',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Informe seu nome';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    // Email (somente leitura)
                    _buildLabel('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue:
                          Supabase.instance.client.auth.currentUser?.email ??
                              '',
                      readOnly: true,
                      decoration: _inputDecoration(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ).copyWith(
                        fillColor: AppColors.cream,
                        suffixIcon: Icon(Icons.lock_outline,
                            size: 18, color: AppColors.textLight),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Idade
                    _buildLabel('Idade'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _idadeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        hint: 'Sua idade',
                        icon: Icons.cake_outlined,
                      ),
                      validator: (v) {
                        if (v != null && v.isNotEmpty) {
                          final n = int.tryParse(v);
                          if (n == null || n < 10 || n > 120) {
                            return 'Idade inválida';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Fase da Vida
                    _buildLabel('Fase da Vida'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightPink),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _faseSelecionada,
                          hint: Text('Selecione',
                              style: TextStyle(color: AppColors.textLight)),
                          isExpanded: true,
                          icon: Icon(Icons.expand_more_rounded,
                              color: AppColors.primaryPink),
                          items: _fases.map((fase) {
                            return DropdownMenuItem(
                              value: fase,
                              child: Text(fase),
                            );
                          }).toList(),
                          onChanged: (v) =>
                              setState(() => _faseSelecionada = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Botão Salvar
                    GradientButton(
                      text: 'SALVAR ALTERAÇÕES',
                      isLoading: _isSaving,
                      onPressed: _saveProfile,
                    ),
                    const SizedBox(height: 16),

                    // Botão Cancelar
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryPink, size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.lightPink),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.lightPink),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryPink, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
