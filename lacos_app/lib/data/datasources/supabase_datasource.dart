import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatasource {
  final SupabaseClient _client;

  SupabaseDatasource(this._client);

  SupabaseClient get client => _client;

  // ---- Auth ----

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ---- Usuarias ----

  Future<void> createUsuaria({
    required String id,
    required String nome,
    required String email,
    int? idade,
    String? faseDaVida,
  }) async {
    await _client.from('usuarias').insert({
      'id': id,
      'nome': nome,
      'email': email,
      'idade': idade,
      'fase_da_vida': faseDaVida,
    });
  }

  Future<Map<String, dynamic>?> getUsuaria(String id) async {
    final response =
        await _client.from('usuarias').select().eq('id', id).maybeSingle();
    return response;
  }

  Future<void> updateUsuaria(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    await _client.from('usuarias').update(data).eq('id', id);
  }

  // ---- Ciclos Menstruais ----

  Future<void> createCiclo(Map<String, dynamic> data) async {
    await _client.from('ciclos_menstruais').insert(data);
  }

  Future<List<Map<String, dynamic>>> getCiclos(String usuarioId) async {
    return await _client
        .from('ciclos_menstruais')
        .select()
        .eq('usuario_id', usuarioId)
        .order('data_inicio', ascending: false);
  }

  Future<void> updateCiclo(String id, Map<String, dynamic> data) async {
    await _client.from('ciclos_menstruais').update(data).eq('id', id);
  }

  Future<void> deleteCiclo(String id) async {
    await _client.from('ciclos_menstruais').delete().eq('id', id);
  }

  // ---- Sintomas ----

  Future<void> createSintoma(Map<String, dynamic> data) async {
    await _client.from('sintomas').insert(data);
  }

  Future<List<Map<String, dynamic>>> getSintomas(String usuarioId) async {
    return await _client
        .from('sintomas')
        .select()
        .eq('usuario_id', usuarioId)
        .order('data', ascending: false);
  }

  Future<void> deleteSintoma(String id) async {
    await _client.from('sintomas').delete().eq('id', id);
  }

  // ---- Conteudos ----

  Future<List<Map<String, dynamic>>> getConteudos() async {
    return await _client.from('conteudos').select().order('titulo');
  }

  Future<List<Map<String, dynamic>>> getConteudosByCategoria(
      String categoria) async {
    return await _client
        .from('conteudos')
        .select()
        .eq('categoria', categoria)
        .order('titulo');
  }

  // ---- Lembretes ----

  Future<void> createLembrete(Map<String, dynamic> data) async {
    await _client.from('lembretes').insert(data);
  }

  Future<List<Map<String, dynamic>>> getLembretes(String usuarioId) async {
    return await _client
        .from('lembretes')
        .select()
        .eq('usuario_id', usuarioId)
        .order('data');
  }

  Future<void> updateLembrete(String id, Map<String, dynamic> data) async {
    await _client.from('lembretes').update(data).eq('id', id);
  }

  Future<void> deleteLembrete(String id) async {
    await _client.from('lembretes').delete().eq('id', id);
  }
}
