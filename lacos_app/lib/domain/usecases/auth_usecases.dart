import '../../data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
    required String nome,
  }) {
    return _repository.signUp(email: email, password: password, nome: nome);
  }
}

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}
