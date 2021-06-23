import 'package:dartz/dartz.dart';
import 'package:get_placed/core/error/failures.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';

abstract class LoginRepository {
  Future<Either<Failure, bool>> login(LoginEntities login);
}
