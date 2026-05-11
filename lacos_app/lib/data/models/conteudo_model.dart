class ConteudoModel {
  final String id;
  final String titulo;
  final String categoria;
  final String? descricao;
  final String? faseDaVida;
  final String? oQueENormal;
  final String? sinaisAlerta;
  final String? quandoProcurarUbs;
  final String? oQueFazerEmCasa;

  ConteudoModel({
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

  factory ConteudoModel.fromJson(Map<String, dynamic> json) {
    return ConteudoModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      categoria: json['categoria'] as String,
      descricao: json['descricao'] as String?,
      faseDaVida: json['fase_da_vida'] as String?,
      oQueENormal: json['o_que_e_normal'] as String?,
      sinaisAlerta: json['sinais_alerta'] as String?,
      quandoProcurarUbs: json['quando_procurar_ubs'] as String?,
      oQueFazerEmCasa: json['o_que_fazer_em_casa'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'descricao': descricao,
      'fase_da_vida': faseDaVida,
      'o_que_e_normal': oQueENormal,
      'sinais_alerta': sinaisAlerta,
      'quando_procurar_ubs': quandoProcurarUbs,
      'o_que_fazer_em_casa': oQueFazerEmCasa,
    };
  }
}
