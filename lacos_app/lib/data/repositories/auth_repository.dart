import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_datasource.dart';

class AuthRepository {
  final SupabaseDatasource _datasource;

  AuthRepository(this._datasource);

  User? get currentUser => _datasource.currentUser;
  Session? get currentSession => _datasource.currentSession;
  Stream<AuthState> get authStateChanges => _datasource.authStateChanges;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nome,
  }) async {
    try {
      final response = await _datasource.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _datasource.createUsuaria(
          id: response.user!.id,
          nome: nome,
          email: email,
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _datasource.signIn(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
