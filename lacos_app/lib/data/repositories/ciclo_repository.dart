import '../datasources/supabase_datasource.dart';
import '../models/ciclo_model.dart';

class CicloRepository {
  final SupabaseDatasource _datasource;

  CicloRepository(this._datasource);

  Future<List<CicloModel>> getCiclos(String usuarioId) async {
    try {
      final data = await _datasource.getCiclos(usuarioId);
      return data.map((json) => CicloModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createCiclo(CicloModel ciclo) async {
    try {
      await _datasource.createCiclo(ciclo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCiclo(String id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateCiclo(id, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCiclo(String id) async {
    try {
      await _datasource.deleteCiclo(id);
    } catch (e) {
      rethrow;
    }
  }
}
