class Lembrete {
  final String id;
  final String usuarioId;
  final String tipo;
  final DateTime data;
  final bool ativo;

  const Lembrete({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.data,
    this.ativo = true,
  });
}
