class LembreteModel {
  final String id;
  final String usuarioId;
  final String tipo;
  final DateTime data;
  final bool ativo;
  final DateTime? createdAt;

  LembreteModel({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.data,
    this.ativo = true,
    this.createdAt,
  });

  factory LembreteModel.fromJson(Map<String, dynamic> json) {
    return LembreteModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: json['tipo'] as String,
      data: DateTime.parse(json['data']),
      ativo: json['ativo'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'tipo': tipo,
      'data': data.toIso8601String(),
      'ativo': ativo,
    };
  }
}
