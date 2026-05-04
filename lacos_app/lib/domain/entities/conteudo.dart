class Conteudo {
  final String id;
  final String titulo;
  final String categoria;
  final String? descricao;
  final String? faseDaVida;
  final String? oQueENormal;
  final String? sinaisAlerta;
  final String? quandoProcurarUbs;
  final String? oQueFazerEmCasa;

  const Conteudo({
    required this.id,
    required this.titulo,
    required this.categoria,
    this.descricao,
    this.faseDaVida,
    this.oQueENormal,
    this.sinaisAlerta,
    this.quandoProcurarUbs,
    this.oQueFazerEmCasa,
  });
}
