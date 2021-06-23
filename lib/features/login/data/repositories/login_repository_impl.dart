import 'package:dartz/dartz.dart';
import 'package:get_placed/core/error/failures.dart';
import 'package:get_placed/features/login/data/datasources/login_user.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';
import 'package:get_placed/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginUser loginUser;

  LoginRepositoryImpl(this.loginUser);
  @override
  Future<Either<Failure, bool>> login(LoginEntities login) async {
    try {
      final user = await loginUser.login(login);
      return Right(user != null);
    } catch (exception) {
      return Left(ServerFailure());
    }
  }
}
