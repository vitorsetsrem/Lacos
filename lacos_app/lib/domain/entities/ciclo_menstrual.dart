class CicloMenstrual {
  final String id;
  final String usuarioId;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final String? intensidade;
  final String? observacoes;

  const CicloMenstrual({
    required this.id,
    required this.usuarioId,
    required this.dataInicio,
    this.dataFim,
    this.intensidade,
    this.observacoes,
  });

  int? get duracaoDias {
    if (dataFim == null) return null;
    return dataFim!.difference(dataInicio).inDays;
  }
}
