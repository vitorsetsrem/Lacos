import '../datasources/supabase_datasource.dart';
import '../models/conteudo_model.dart';

class ConteudoRepository {
  final SupabaseDatasource _datasource;

  ConteudoRepository(this._datasource);

  Future<List<ConteudoModel>> getConteudos() async {
    try {
      final data = await _datasource.getConteudos();
      return data.map((json) => ConteudoModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ConteudoModel>> getConteudosByCategoria(
      String categoria) async {
    try {
      final data = await _datasource.getConteudosByCategoria(categoria);
      return data.map((json) => ConteudoModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
