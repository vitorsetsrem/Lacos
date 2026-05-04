class Sintoma {
  final String id;
  final String usuarioId;
  final String tipo;
  final String? intensidade;
  final DateTime data;
  final String? descricao;

  const Sintoma({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    this.intensidade,
    required this.data,
    this.descricao,
  });
}
