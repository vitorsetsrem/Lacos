import '../../data/models/conteudo_model.dart';
import '../../data/repositories/conteudo_repository.dart';

class GetConteudosUseCase {
  final ConteudoRepository _repository;

  GetConteudosUseCase(this._repository);

  Future<List<ConteudoModel>> call() {
    return _repository.getConteudos();
  }
}

class GetConteudosByCategoriaUseCase {
  final ConteudoRepository _repository;

  GetConteudosByCategoriaUseCase(this._repository);

  Future<List<ConteudoModel>> call(String categoria) {
    return _repository.getConteudosByCategoria(categoria);
  }
}
