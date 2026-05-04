class SintomaModel {
  final String id;
  final String usuarioId;
  final String tipo;
  final String? intensidade;
  final DateTime data;
  final String? descricao;

  SintomaModel({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    this.intensidade,
    required this.data,
    this.descricao,
  });

  factory SintomaModel.fromJson(Map<String, dynamic> json) {
    return SintomaModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: json['tipo'] as String,
      intensidade: json['intensidade'] as String?,
      data: DateTime.parse(json['data'] as String),
      descricao: json['descricao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'tipo': tipo,
      'intensidade': intensidade,
      'data': data.toIso8601String(),
      'descricao': descricao,
    };
  }
}
