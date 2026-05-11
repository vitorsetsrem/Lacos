class CicloModel {
  final String id;
  final String usuarioId;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final String? intensidade;
  final String? observacoes;

  CicloModel({
    required this.id,
    required this.usuarioId,
    required this.dataInicio,
    this.dataFim,
    this.intensidade,
    this.observacoes,
  });

  factory CicloModel.fromJson(Map<String, dynamic> json) {
    return CicloModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      dataInicio: DateTime.parse(json['data_inicio'] as String),
      dataFim: json['data_fim'] != null
          ? DateTime.parse(json['data_fim'] as String)
          : null,
      intensidade: json['intensidade'] as String?,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'data_inicio': dataInicio.toIso8601String().split('T').first,
      'data_fim': dataFim?.toIso8601String().split('T').first,
      'intensidade': intensidade,
      'observacoes': observacoes,
    };
  }
}
