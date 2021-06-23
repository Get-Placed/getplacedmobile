import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get_placed/core/error/failures.dart';
import 'package:get_placed/core/error/usecase.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';
import 'package:get_placed/features/login/domain/repositories/login_repository.dart';

class Login implements UseCase<bool, Params> {
  final LoginRepository loginRepository;

  Login(this.loginRepository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await loginRepository.login(params.login);
  }
}

class Params extends Equatable {
  final LoginEntities login;

  Params({
    required this.login,
  });

  @override
  List<Object> get props => [login];
}
