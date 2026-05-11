import '../../data/models/ciclo_model.dart';
import '../../data/repositories/ciclo_repository.dart';

class GetCiclosUseCase {
  final CicloRepository _repository;

  GetCiclosUseCase(this._repository);

  Future<List<CicloModel>> call(String usuarioId) {
    return _repository.getCiclos(usuarioId);
  }
}

class CreateCicloUseCase {
  final CicloRepository _repository;

  CreateCicloUseCase(this._repository);

  Future<void> call(CicloModel ciclo) {
    return _repository.createCiclo(ciclo);
  }
}

class DeleteCicloUseCase {
  final CicloRepository _repository;

  DeleteCicloUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteCiclo(id);
  }
}
