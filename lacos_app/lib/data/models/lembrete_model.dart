class LembreteModel {
  final String id;
  final String usuarioId;
  final String tipo;
  final DateTime data;
  final bool ativo;

  LembreteModel({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.data,
    this.ativo = true,
  });

  factory LembreteModel.fromJson(Map<String, dynamic> json) {
    return LembreteModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: json['tipo'] as String,
      data: DateTime.parse(json['data'] as String),
      ativo: json['ativo'] as bool? ?? true,
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
