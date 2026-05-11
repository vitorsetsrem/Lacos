import 'package:flutter/material.dart';

/// Paleta de cores oficial do Laço's - Minha Saúde Feminina
/// Baseada na identidade visual documentada do projeto.
class AppColors {
  AppColors._();

  // =============================================
  // PALETA PRINCIPAL (Identidade Visual Oficial)
  // =============================================
  /// Creme claro - fundo principal
  static const Color cream = Color(0xFFFBF4EB);

  /// Rosa suave - backgrounds de cards/destaques
  static const Color softPink = Color(0xFFFBD9E5);

  /// Vermelho rosado - cor primária de destaque (CTAs, ícones ativos)
  static const Color primaryRed = Color(0xFFC43A4A);

  /// Rosa médio - cor secundária (elementos complementares)
  static const Color roseMedium = Color(0xFFC56682);

  /// Salmão/pêssego - cor terciária (acentos suaves)
  static const Color salmon = Color(0xFFE7A48C);

  // =============================================
  // CORES DERIVADAS (para uso em componentes)
  // =============================================
  static const Color primaryPink = Color(0xFFC43A4A);
  static const Color primaryLilas = Color(0xFFC56682);
  static const Color lightPink = Color(0xFFFBD9E5);
  static const Color lightLilas = Color(0xFFF5E6EC);
  static const Color pastelPink = Color(0xFFFBD9E5);
  static const Color pastelLilas = Color(0xFFFBF4EB);
  static const Color background = Color(0xFFFBF4EB);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  // =============================================
  // GRADIENTES
  // =============================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryRed, roseMedium],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [cream, softPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient salmonGradient = LinearGradient(
    colors: [salmon, roseMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
