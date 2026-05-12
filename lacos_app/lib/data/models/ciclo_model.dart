class CicloModel {
  final String id;
  final String usuarioId;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final String? intensidade;
  final String? observacoes;
  final DateTime? createdAt;

  CicloModel({
    required this.id,
    required this.usuarioId,
    required this.dataInicio,
    this.dataFim,
    this.intensidade,
    this.observacoes,
    this.createdAt,
  });

  factory CicloModel.fromJson(Map<String, dynamic> json) {
    return CicloModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      dataInicio: DateTime.parse(json['data_inicio']),
      dataFim:
          json['data_fim'] != null ? DateTime.tryParse(json['data_fim']) : null,
      intensidade: json['intensidade'] as String?,
      observacoes: json['observacoes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'data_inicio': dataInicio.toIso8601String().substring(0, 10),
      'data_fim': dataFim?.toIso8601String().substring(0, 10),
      'intensidade': intensidade,
      'observacoes': observacoes,
    };
  }
}
